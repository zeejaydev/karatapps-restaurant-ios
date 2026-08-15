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
    
//    init() {
//        Thread.sleep(forTimeInterval: 2)
//    }
    
    var body: some Scene {
        LaunchScreen {
            LoadingLaunch()
        } rootContent: {
            AppRootView()
                .modelContainer(sharedModelContainer)
                .environment(appVM)
        }

    }
}
