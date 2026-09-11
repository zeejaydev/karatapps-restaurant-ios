//
//  CloverCheckoutWebView.swift
//  Restaurant
//
//  Created by Zaid Jamil on 9/5/26.
//

import SwiftUI
import WebKit

struct CloverCheckoutWebView: UIViewRepresentable {
    @Environment(\.colorScheme) private var colorScheme
    let apiAccessKey: String // public PAKMS key from your backend
    let merchantId: String // MID
    @Binding var token: String?
    @Binding var errorMessage: String?
    @Binding var log: [String]
    @Binding var cards: [CloverCardResult.CloverCard]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.userContentController.add(context.coordinator, name: "clover")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.bounces = false
        
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        
        // Use an https origin you control, not about:blank — cross-origin
        // iframes (Clover elements) can be finicky with a null parent origin.
        let base = Configuration.brandURL
        webView.loadHTMLString(Self.html(
            apiAccessKey: apiAccessKey,
            merchantId: merchantId,
            colorScheme: colorScheme
        ), baseURL: base)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        context.coordinator.parent = self
    }

    static func dismantleUIView(_ webView: WKWebView, coordinator: Coordinator) {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "clover")
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        var parent: CloverCheckoutWebView

        init(_ parent: CloverCheckoutWebView) {
            self.parent = parent
        }

        private func append(_ line: String) {
            print(line)
            parent.log.append(line)
        }

        func userContentController(
            _ controller: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            guard let body = message.body as? [String: Any],
                  let type = body["type"] as? String else {
                append("unrecognized message: \(message.body)")
                return
            }

            switch type {
            case "ready":
                append("card fields mounted")

            case "log":
                append("[web] \(body["message"] ?? "")")

            case "error":
                let text = body["message"] as? String ?? "unknown error"
                append("[web error] \(text)")
                parent.errorMessage = text

            case "tokenResult":
                let payload = body["payload"] as? [String: Any] ?? [:]
                append("tokenResult: \(payload)")
                if let errors = payload["errors"] as? [String: Any] {
                    parent.errorMessage = errors.values
                        .compactMap { $0 as? String }
                        .joined(separator: " ")
                } else if let token = payload["token"] as? String {
                    parent.token = token
                    parent.errorMessage = nil
                }
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: payload)
                    let result = try JSONDecoder().decode(CloverCardResult.self, from: data)
                    parent.cards.append(result.card)
                } catch {
                    print(error)
                }
            default:
                append("unhandled message type: \(type)")
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            append("page loaded")
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            append("navigation failed: \(error.localizedDescription)")
            parent.errorMessage = error.localizedDescription
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            append("provisional navigation failed: \(error.localizedDescription)")
            parent.errorMessage = error.localizedDescription
        }
    }

    // MARK: - HTML

    private static func html(apiAccessKey: String, merchantId: String, colorScheme: ColorScheme) -> String {
        let bg = colorScheme == .dark ? "#121212" : "#F5F6F8"
        let textColor = colorScheme == .dark ? "#FFFFFF" : "#000000"
        let border = colorScheme == .dark ? "#1F1F1F" : "#E2E8F0"
        let buttonColor = "#C7FF00"
        let sdkUrl = Configuration.cloverSdkUrl
        print(sdkUrl)
        return """
        <!doctype html>
        <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
          <style>
            body { font-family: -apple-system, sans-serif; margin: 16px; background: \(bg); color: \(textColor) }
            label { display: block; margin: 12px 0 4px; font-size: 14px; font-weight: 600; }
            .field { border: 1px solid \(border); border-radius: 8px; padding: 10px; height: 24px; background: \(bg); }
            button { margin-top: 20px; width: 100%; padding: 14px; font-size: 16px;
                     border: 0; border-radius: 8px; background: \(buttonColor); color: black; font-weight: 600; }
            button:disabled { opacity: 0.5; }
            a {color: \(textColor)}
          </style>
        </head>
        <body>
            <form id="payment-form">
            <label>Card number</label>
            <div id="card-number" class="field"></div>
            <label>Expiration</label>
            <div id="card-date" class="field"></div>
            <label>CVV</label>
            <div id="card-cvv" class="field"></div>
            <label>Zip Code</label>
            <div id="card-postal-code" class="field"></div>
            <button id="submit" type="submit">Add Card</button>
            </form>

            <script src=\(sdkUrl)></script>
            <script>
                const post = (msg) => window.webkit.messageHandlers.clover.postMessage(msg);
                const describe = (v) => typeof v === 'string' ? v : JSON.stringify(v);
                const log = (...args) => post({ type: 'log', message: args.map(describe).join(' ') });
                const fail = (message) => post({ type: 'error', message: message });

                // Without these two, any JS failure is completely silent on the native side.
                window.onerror = (message, source, line) => fail(message + ' (line ' + line + ')');
                window.addEventListener('unhandledrejection', (e) => {
                    fail('unhandled rejection: ' + describe(e.reason && e.reason.message || e.reason));
                });

                // Surfaces a pending-forever promise instead of just hanging.
                const withTimeout = (promise, ms) => Promise.race([
                    promise,
                    new Promise((_, reject) => setTimeout(
                    () => reject(new Error('createToken timed out after ' + ms + 'ms')), ms
                    ))
                ]);

                try {
                    if (typeof Clover === 'undefined') {
                        fail('sdk.js failed to load — Clover is undefined');
                    } else {
                        const clover = new Clover('\(apiAccessKey)', { merchantId: '\(merchantId)' });
                        const elements = clover.elements();
                        const styles = { 
                            input: { fontSize: '16px', fontFamily: '-apple-system, sans-serif', background: 'transparent', color: '\(textColor)' },
                        };

                        const cardNumber = elements.create('CARD_NUMBER', styles);
                        const cardDate   = elements.create('CARD_DATE', styles);
                        const cardCvv    = elements.create('CARD_CVV', styles);
                        const cardPostal = elements.create('CARD_POSTAL_CODE', styles);

                        cardNumber.mount('#card-number');
                        cardDate.mount('#card-date');
                        cardCvv.mount('#card-cvv');
                        cardPostal.mount('#card-postal-code');

                        post({ type: 'ready' });

                        document.getElementById('payment-form').addEventListener('submit', async (e) => {
                            e.preventDefault();
                            const btn = document.getElementById('submit');
                            btn.disabled = true;
                            log('submit tapped, calling createToken');
                            try {
                            const result = await withTimeout(clover.createToken(), 15000);
                            post({ type: 'tokenResult', payload: result });
                            } catch (err) {
                            fail('createToken threw: ' + describe(err && err.message || err));
                            } finally {
                            btn.disabled = false;
                            }
                        });
                    }
                } catch (err) {
                    fail('setup failed: ' + describe(err && err.message || err));
                }
            </script>
            <script>
                const footer = document.querySelector(".clover-footer");
                if (footer) {
                    footer.style.backgroundColor = "transparent"
                }
            </script>
        </body>
        </html>
        """
    }
}
