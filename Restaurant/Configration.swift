//
//  Configration.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/9/26.
//

import Foundation

enum AppEnvironment {
    case development
    case staging
    case production

    static var current: AppEnvironment {
        #if STAGING
        return .staging
        #elseif DEBUG
        return .development
        #else
        return .production
        #endif
    }
}

struct Configuration {
    static func value(_ key: String) -> String {
               guard let v = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
                   fatalError("Missing Info.plist key \(key)")
               }
               return v
           }
    
    static let apiBaseURL = URL(string: value("API_BASE_URL"))!

//    static var socketURL: String {
//        switch AppEnvironment.current {
//        case .development:
//            return "http://192.168.77.177:83"
//        case .staging:
//            return ""
//        case .production:
//            return ""
//        }
//    }

    static var analyticsEnabled: Bool {
        return AppEnvironment.current == .production
    }
}
