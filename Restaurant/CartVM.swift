//
//  CartVM.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/28/26.
//

import Foundation
import Observation

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
    }
    
    func remobeFromCart(id: UUID) {
        guard let index = cart.firstIndex(where: { $0.id == id }) else { return }
        cart.remove(at: index)
    }
    
}
