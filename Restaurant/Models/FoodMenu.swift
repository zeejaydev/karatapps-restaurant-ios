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
        id: 65,
        brandLocationId: 1,
        sortOrder: 0,
        stockCount: 0,
        price: 1429,
        cost: 0,
        name: "Best Seller",
        posItemId: "K6D80TC806XKG",
        isAvailable: true,
        isAgeRestricted: false,
        enabledOnline: true,
        isHidden: false,
        onlineName: "Best Seller",
        description: "Regular Teriyaki Chicken - 3 pieces of chicken marinated and drizzled with our house made Teri Sauce; served on a bed of cabbage with 2 scoops of rice, 1 salad choice, and 2 sauce cups.  For sides customization, please call and order from the store.",
        altName: nil,
        images: [
            .init(url:"https://olo-images-live.imgix.net/c9/c9f0c54177cd46aa98b8b6a827beee89.png?auto=format%2Ccompress&q=60&cs=tinysrgb&w=1200&h=800&fit=fill&fm=png32&bg=transparent&s=7191284232c6183463f8a207b99eefa1")
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
