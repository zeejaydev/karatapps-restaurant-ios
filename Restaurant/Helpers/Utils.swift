//
//  Utils.swift
//  Restaurant
//
//  Created by Zaid Jamil on 9/7/26.
//

import Foundation

enum PhoneFormatter {
    /// "8015551234" -> "(801) 555-1234"
    static func format(_ input: String) -> String {
        var digits = input.filter(\.isNumber)

        // Handle a leading US country code so paste works
        if digits.count == 11, digits.hasPrefix("1") {
            digits.removeFirst()
        }
        digits = String(digits.prefix(10))

        switch digits.count {
        case 0:
            return ""
        case 1...3:
            return "(\(digits)"
        case 4...6:
            let area = digits.prefix(3)
            let mid = digits.dropFirst(3)
            return "(\(area)) \(mid)"
        default:
            let area = digits.prefix(3)
            let mid = digits.dropFirst(3).prefix(3)
            let last = digits.dropFirst(6)
            return "(\(area)) \(mid)-\(last)"
        }
    }

    /// What you send to the API
    static func digits(_ input: String) -> String {
        String(input.filter(\.isNumber).suffix(10))
    }
}

struct CurrencyMask {
    static let currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = .current
        f.maximumFractionDigits = 0
        f.minimumFractionDigits = 0
        return f
    }()
    
    static func maskedCurrency(_ input: String) -> String {
        let digits = input.filter(\.isNumber)
        guard !digits.isEmpty else { return "" }
        let value = Int(digits.prefix(7)) ?? 0
        return currencyFormatter.string(from: NSNumber(value: value)) ?? ""
    }
}
