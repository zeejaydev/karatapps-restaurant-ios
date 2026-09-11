//
//  ContentView.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/8/26.
//

import SwiftUI

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

enum MenuRoute: Hashable {
    case cart
    case checkout
}

@Observable
final class Router {
    var path = NavigationPath()
    func popToRoot() { path = NavigationPath() }
}

struct MainTabView: View {
    ///using enviroment not enviromentObject becuse I'm using the new observable macro in the appVM
    ///so i only rerender the changed value instead of the whole object
    @Environment(AppVM.self) private var appVM
    @State var activeTab: AppTabs = .home
    @State private var cartVM: CartVM = CartVM()
    @State private var router = Router()

    var body: some View {
        TabView(selection: $activeTab) {
            Tab.init(value: .home) {
                NavigationStack {
                    ZStack {
                        Color.BG.ignoresSafeArea()
                        Home(viewModel: HomeVM(), activeTab: $activeTab)
                    }
                }
            } label: {
                Image(systemName: AppTabs.home.symbol)
            }
            
            Tab.init(value: .menu) {
                NavigationStack(path: $router.path) {
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
        .environment(router)
        .toolbarBackground(Color.BG, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.BG, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            cartVM.selectedLocation = appVM.selectedLocation
        }
    }
}

#Preview {
    MainTabView()
        .environment(AppVM())
        .environment(\.font, .appBody)
}
