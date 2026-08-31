//
//  CartVM.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/28/26.
//

import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
class CartVM {
    var cart: [CartItem] = []
    var itemsCount: Int {
        cart.map({$0.quantity}).reduce(0, +)
    }
    
    func addToCart(item: FoodMenuItem, quantity: Int, modifiers: [String:Modifier]) {
        let cartItem = CartItem(foodItem: item, quantity: quantity, selectedModifiers: modifiers)
        cart.append(cartItem)
        print(cart)
    }
    
    func updateCartItem(
        id: UUID,
        quantity: Int,
        modifiers: [String: Modifier]
    ) {
        guard let index = cart.firstIndex(where: { $0.id == id }) else {
            return
        }
        cart[index].quantity = quantity
        cart[index].selectedModifiers = modifiers
    }
    
    func removeFromCart(atOffsets offsets: IndexSet) {
        cart.remove(atOffsets: offsets)
    }
    
    
    ///Preview
    func loadMockData() {
        for _ in 0..<4 {
            cart.append(CartItem.mock)
        }
    }
}
