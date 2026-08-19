//
//  AppRootView.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/14/26.
//

import SwiftUI

struct AppRootView: View {
    @Environment(AppVM.self) private var appVM
    @Environment(\.dismissSplash) private var dismissSplash
    @State private var continueWithoutUser: Bool = false
    
    var body: some View {
       Group {
           switch appVM.phase {
           case .loading:
               Color.BG.ignoresSafeArea()
           case .ready:
               if appVM.user || continueWithoutUser {
                   MainTabView()
               } else {
                   IntroView(continueWithoutUser: $continueWithoutUser)
               }
           case .failed:
               Text("error")
           }
        }
        .onChange(of: appVM.phase) { _, phase in
            if phase != .loading {
                dismissSplash?()
            }
        }
        .task {
            guard case .loading = appVM.phase else {
                return
            }
            await appVM.load()
        }
    }
}
