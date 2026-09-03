//
//  Order.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/21/26.
//

import Foundation

struct OrderType: Codable {
    let id, brandLocationId, avgOrderTime, fee: Int
    let label, cloverId: String
    let taxable: Bool
}

struct OrderPayload: Codable {
    let items: [OrderPayloadItem]
    let orderTypeId: String
    
    struct OrderPayloadItem: Codable {
        let id: String
        let modifiers: [Modifier]
    }
    
    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
