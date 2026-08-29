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
    let quantity: Int
    let selectedModifiers: [String: Modifier]
}
