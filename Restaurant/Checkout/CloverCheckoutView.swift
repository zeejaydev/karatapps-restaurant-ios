//
//  CloverCheckoutView.swift
//  Restaurant
//
//  Created by Zaid Jamil on 9/5/26.
//

import SwiftUI

struct CloverCheckoutView: View {
    @Environment(\.dismiss) var dismiss
    let apiAccessKey: String
    let locationId: String
    @Binding var cards: [CloverCardResult.CloverCard]
    @Binding var token: String?
    @State private var errorMessage: String?
    @State private var log: [String] = []
    
    var body: some View {
        VStack(spacing: 0) {
            CloverCheckoutWebView(
                apiAccessKey: apiAccessKey,
                merchantId: locationId,
                token: $token,
                errorMessage: $errorMessage,
                log: $log,
                cards: $cards
            )
            .background(Color.BG)

            if let token {
                Text("Token: \(token)").font(.footnote).padding()
            }
            if let errorMessage {
                Text(errorMessage).foregroundStyle(.red).font(.footnote).padding()
            }

//            debugConsole
        }
        .onChange(of: token) { _, token in
            dismiss()
        }
        .background(.BG)
    }

    /// Bridge output rendered in-view, since `print` isn't visible from a #Preview.
    private var debugConsole: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(log.enumerated()), id: \.offset) { index, line in
                        Text(line)
                            .font(.system(size: 11, design: .monospaced))
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .id(index)
                    }
                }
                .padding(8)
            }
            .onChange(of: log.count) { _, count in
                withAnimation { proxy.scrollTo(count - 1, anchor: .bottom) }
            }
        }
        .frame(height: 180)
        .background(.surface)
        .overlay(alignment: .top) {
            Rectangle().fill(.separator).frame(height: 1)
        }
    }
}

#Preview {
    @Previewable @State var cards: [CloverCardResult.CloverCard] = []
    @Previewable @State var token: String? = nil
    
    CloverCheckoutView(
        apiAccessKey: "24b33ac6e140e37ef0eed47dd7ad0733",
        locationId: "XBA77DN2HNS41",
        cards: $cards,
        token: $token
    )
}
