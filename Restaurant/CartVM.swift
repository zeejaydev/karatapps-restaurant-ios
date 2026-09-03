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
    let networkService: NetworkService = NetworkService.shared
    var cart: [CartItem] = []
    var total: CartTotal = CartTotal(subtotal: 0, tax: 0, total: 0)
    var itemsCount: Int {
        cart.map({$0.quantity}).reduce(0, +)
    }
    var selectedLocation: RestaurantLocation? = nil
    
    func addToCart(item: FoodMenuItem, quantity: Int, modifiers: [String:Modifier]) {
        let cartItem = CartItem(foodItem: item, quantity: quantity, selectedModifiers: modifiers)
        cart.append(cartItem)
        Task {
           await calculateTotal()
        }
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
        Task {
           await calculateTotal()
        }
    }
    
    func removeFromCart(atOffsets offsets: IndexSet) {
        cart.remove(atOffsets: offsets)
        Task {
           await calculateTotal()
        }
    }
    
    private func calculateTotal() async {
        guard let locationId = selectedLocation?.posLocationId,
              let orderTypeId = selectedLocation?.orderTypes.first?.cloverId else {
            print("Slecting location and order type is required")
            return
        }
        
        let items = cart.flatMap { cartItem in
            let item = OrderPayload.OrderPayloadItem(
                id: cartItem.foodItem.posItemId,
                modifiers: Array(cartItem.selectedModifiers.values)
            )
            return Array(
                repeating: item,
                count: max(0, cartItem.quantity)
            )
        }
        
        let payload = OrderPayload(items: items, orderTypeId: orderTypeId)
        
        do {
            let resp = try await networkService.apiCall(
                method: .post,
                route: "/orders/\(locationId)/checkout",
                data: payload.toData(),
                responseType: CartTotal.self
            )
            
            total = resp
        } catch {
            print(error)
        }
    }
    
    ///Preview
    func loadMockData() {
        for _ in 0..<4 {
            cart.append(CartItem.mock)
        }
    }
}
