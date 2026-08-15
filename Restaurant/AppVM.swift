//
//  AppVM.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/9/26.
//

import Foundation
import Observation

@MainActor
@Observable
public final class AppVM {
    enum Phase {
        case loading
        case ready
        case failed
    }
    
    var phase: Phase = .loading
    
    func load() async {
        do {
            // Run independent calls in parallel
//            async let config = APIClient.shared.fetchAppConfig()
//            async let user = APIClient.shared.fetchCurrentUser()
//            async let menu = APIClient.shared.fetchMenu()
//
//            let (cfg, usr, mnu) = try await (config, user, menu)

            // Stash into your stores/environment objects here
//            AppState.shared.apply(config: cfg, user: usr, menu: mnu)
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.phase = .ready
            }
        } catch {
            phase = .failed
        }
    }
}
