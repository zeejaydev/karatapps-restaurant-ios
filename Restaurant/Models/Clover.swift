//
//  Clover.swift
//  Restaurant
//
//  Created by Zaid Jamil on 9/6/26.
//

import Foundation

struct CloverCardResult: Codable {
    let token: String
    let card: CloverCard
    
    struct CloverCard: Codable, Identifiable {
        // Client-side identity only — Clover doesn't send an id, so it's kept
        // out of CodingKeys. Synthesized decoding ignores default values and
        // would otherwise throw keyNotFound for "id".
        var id: UUID = UUID()
        let brand, address_zip: String
        let exp_month, exp_year, first6, last4: String

        private enum CodingKeys: String, CodingKey {
            case brand, address_zip, exp_month, exp_year, first6, last4
        }
    }
}
