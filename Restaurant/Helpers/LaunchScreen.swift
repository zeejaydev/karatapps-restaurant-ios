//
//  LaunchScreen.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/11/26.
//

import SwiftUI

struct LaunchScreen<SplashContent: View, RootContent: View>: Scene {
    @ViewBuilder var splashContent: () -> SplashContent
    @ViewBuilder var rootContent: RootContent

    var body: some Scene {
        WindowGroup {
            LaunchScreenHost {
                splashContent()
            } rootContent: {
                rootContent
            }
        }
    }
}

private struct DismissSplashKey: EnvironmentKey {
    static let defaultValue: (() -> Void)? = nil
}

extension EnvironmentValues {
    var dismissSplash: (() -> Void)? {
        get { self[DismissSplashKey.self] }
        set { self[DismissSplashKey.self] = newValue }
    }
}

private struct LaunchScreenHost<SplashContent: View, RootContent: View>: View {
    var splashContent: SplashContent
    var rootContent: RootContent
    @State private var showSplash = true

    init(
        @ViewBuilder splashContent: () -> SplashContent,
        @ViewBuilder rootContent: () -> RootContent
    ) {
        self.splashContent = splashContent()
        self.rootContent = rootContent()
    }

    var body: some View {
        ZStack {
            Color.BG
                .ignoresSafeArea()

            rootContent
                .environment(\.dismissSplash, {
                    withAnimation(.easeOut(duration: 0.25)) {
                        showSplash = false
                    }
                })

            if showSplash {
                splashContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
    }
}
