//
//  ContentView.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/8/26.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    ///using enviroment not enviromentObject becuse I'm using the new observable macro in the appVM
    ///so i only rerender the changed value instead of the whole object
    @Environment(AppVM.self) private var bootstrapper
    @State var activeTab: Int = 0
    
    var body: some View {
        TabView(selection: $activeTab) {
            Text("Hellw ")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.BG.ignoresSafeArea())
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
        }
    }
}

#Preview {
    MainTabView()
        .environment(AppVM())
}
