//
//  RestaurantLocation.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/21/26.
//

import Foundation

struct RestaurantLocation: Codable {
    let  id, tokenId: Int
    let brandId, posLocationId, name, address, city, state, zip, phone: String
    let businessHours: BusinessHours
    let isActive: Bool;
    let orderTypes: [OrderType];
    
    struct BusinessHours: Codable {
        let id, name: String
        let schedule: [LocationSchedule];
    }
    
    struct LocationSchedule: Codable {
        let day, open, close: String
        let closed: Bool
    }
}

