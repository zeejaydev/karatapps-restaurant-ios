//
//  Cart.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/29/26.
//

import Foundation

struct CartItem: Identifiable {
    let id = UUID()
    let foodItem: FoodMenuItem
    var quantity: Int
    var selectedModifiers: [String: Modifier]
    
    static var mock: Self {
        return CartItem(
            foodItem: FoodMenuItem(
                id: 18,
                brandLocationId: 1,
                sortOrder: 0,
                stockCount: 0,
                price: 1699,
                cost: 0,
                name: "Medium Chicken Bacon Ranch",
                posItemId: "GNGDYJJ2705AC",
                isAvailable: true,
                isAgeRestricted: false,
                enabledOnline: true,
                isHidden: false,
                onlineName: nil,
                description: "test description, just for desplaying",
                altName: Optional(""),
                images: [
                    .init(url:"https://images.unsplash.com/photo-1571091718767-18b5b1457add?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8YnVyZ2Vyc3xlbnwwfHwwfHx8MA%3D%3D")
                ]
            ),
            quantity: 2,
            selectedModifiers: [
                "2N5FCS55X6MZ6": Restaurant.Modifier(
                    id: 743,
                    price: 175,
                    sortOrder: 0,
                    posModifierId: "2N5FCS55X6MZ6",
                    name: "Roasted Reds",
                    isAvailable: true
                ),
                "9C398ZTM15DM6": Restaurant.Modifier(
                    id: 742,
                    price: 350,
                    sortOrder: 0,
                    posModifierId: "9C398ZTM15DM6",
                    name: "Ricotta (Premium Topping)",
                    isAvailable: true
                ),
                "BDA6RZBK0ZRYG": Restaurant.Modifier(
                    id: 744,
                    price: 350,
                    sortOrder: 0,
                    posModifierId: "BDA6RZBK0ZRYG",
                    name: "Steak (Premium Topping)",
                    isAvailable: true
                )
            ]
        )
    }
}
