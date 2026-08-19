//
//  RestaurantApp.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/8/26.
//

import SwiftUI
import SwiftData

@main
struct RestaurantApp: App {
    @State private var appVM: AppVM = AppVM()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
//        Thread.sleep(forTimeInterval: 2)
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font: UIFont(name: "Inter18pt-SemiBold", size: 17)!
        ]
        appearance.largeTitleTextAttributes = [
            .font: UIFont(name: "Inter18pt-Bold", size: 34)!
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        UITabBarItem.appearance().setTitleTextAttributes(
            [.font: UIFont(name: "Inter18pt-Medium", size: 12)!], for: .normal
        )
    }
    
    var body: some Scene {
        LaunchScreen {
            LoadingLaunch()
        } rootContent: {
            ZStack {
                Color.BG.ignoresSafeArea()
                AppRootView()
                    .background(Color.BG.ignoresSafeArea())
                    .modelContainer(sharedModelContainer)
                    .environment(appVM)
                    .environment(\.font, .appBody)
            }
        }

    }
}
