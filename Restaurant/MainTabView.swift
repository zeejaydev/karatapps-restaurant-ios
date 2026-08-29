//
//  ContentView.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/8/26.
//

import SwiftUI
import SwiftData

enum AppTabs: String, CaseIterable {
    case home = "Home"
    case menu = "Menu"
    case orders = "Orders"
    case profile = "Profile"
    
    var symbol: String {
        switch self {
        case .home:
            return "house"
        case .menu:
            return "fork.knife"
        case .orders:
            return "list.dash.header.rectangle"
        case .profile:
            return "person"
        }
    }
}

struct MainTabView: View {
    ///using enviroment not enviromentObject becuse I'm using the new observable macro in the appVM
    ///so i only rerender the changed value instead of the whole object
    @Environment(AppVM.self) private var appVM
    @State var activeTab: AppTabs = .home
    @State private var cartVM: CartVM = CartVM()
    
    var body: some View {
        TabView(selection: $activeTab) {
            Tab.init(value: .home) {
                NavigationStack {
                    ZStack {
                        Color.BG.ignoresSafeArea()
                        Home(viewModel: HomeVM())
                    }
                }
            } label: {
                Image(systemName: AppTabs.home.symbol)
            }
            
            Tab.init(value: .menu) {
                NavigationStack{
                    ZStack {
                        Color.BG.ignoresSafeArea()
                        Menu()
                            .toolbar(.hidden, for: .navigationBar)
                    }
                }
            } label: {
                Image(systemName: AppTabs.menu.symbol)
            }
            
            Tab(value: .orders) {
                NavigationStack{
                    ZStack{
                        Color.BG.ignoresSafeArea()
                        Text("Orders")
                    }
                }
            } label: {
                Image(systemName: AppTabs.orders.symbol)
            }
            
            Tab(value: .profile) {
                NavigationStack {
                    ZStack {
                        Color.BG.ignoresSafeArea()
                        Text("Profile")
                    }
                }
            } label: {
                Image(systemName: AppTabs.profile.symbol)
            }
        }
        .environment(appVM)
        .environment(cartVM)
        .toolbarBackground(Color.BG, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.BG, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    MainTabView()
        .environment(AppVM())
        .environment(\.font, .appBody)
}
