//
//  FoodMenu.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/21/26.
//

import Foundation

struct FoodMenuCategory: Codable, Identifiable {
    let id, brandLocationId, sortOrder, itemsCount: Int
    let name, description: String
    let imageUrl: String?
    let isAvailable: Bool
//    let lastSyncedAt: Date
}

struct FoodMenuItem: Codable, Identifiable {
    let id, brandLocationId, sortOrder, stockCount, price, cost: Int
    let name, posItemId: String
    let isAvailable, isAgeRestricted, enabledOnline, isHidden: Bool
    let onlineName, description, altName: String?
    let images: [MenuItemImage]
    //    let lastSyncedAt: Date
    
    struct MenuItemImage: Codable {
        let url: String
    }
    
    static let mock: Self = .init(
        id: 83,
        brandLocationId: 1,
        sortOrder: 0,
        stockCount: 0,
        price: 1899,
        cost: 0,
        name: "New Yorker Pizza",
        posItemId: "F4QD4XAN4S14Y",
        isAvailable: true,
        isAgeRestricted: false,
        enabledOnline: true,
        isHidden: false,
        onlineName: "Shrimp Special",
        description: "Double smash organic beef patties, aged cheddar cheese, charred onions, and fresh house-made garlic truffle aioli on a soft toasted brioche bun.",
        altName: nil,
        images: [
            .init(url:"https://images.unsplash.com/photo-1571091718767-18b5b1457add?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8YnVyZ2Vyc3xlbnwwfHwwfHx8MA%3D%3D")
        ]
    )
}

struct ModifierGroup: Codable, Identifiable {
  let id, minRequired: Int
  let modifierGroupName: String
  let maxAllowed: Int?
  let modifiers: [Modifier];
}

struct Modifier: Codable, Identifiable, Equatable {
  let id, price, sortOrder: Int
  let posModifierId, name: String
  let isAvailable: Bool;
};
