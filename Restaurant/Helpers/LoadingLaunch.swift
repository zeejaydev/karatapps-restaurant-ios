//
//  LoadingLaunch.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/15/26.
//

import SwiftUI

struct LoadingLaunch: View {
    var body: some View {
        ZStack {
            Color.BG

            Image(.launchScreenBG)
                .resizable()
                .scaledToFill()

            Color.BG.opacity(0.9)

            Text("My Restaurant")
                .font(.appDisplay)
                
        }
        .clipped()
        .ignoresSafeArea()
    }
}

#Preview {
    LoadingLaunch()
}
