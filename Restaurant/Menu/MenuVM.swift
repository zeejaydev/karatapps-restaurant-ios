//
//  MenuVM.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/21/26.
//

import Foundation
import Observation

@MainActor
@Observable
class MenuVM {
    let networkService: NetworkService = NetworkService.shared
    ///Cache items after first fetch by CategoryId:CategoryItems
    var categoryItems: [Int:[FoodMenuItem]] = [:]
    var loadingCategoryItems: Bool = false
    
    func loadCategoryItems(categoryId: Int) async {
        guard categoryItems[categoryId] == nil else { return }
        loadingCategoryItems = true
        do {
            let items = try await networkService.apiCall(
                route: "/\(categoryId)/items",
                responseType: [FoodMenuItem].self
            )
            categoryItems[categoryId] = items.sorted { $0.sortOrder < $1.sortOrder }
        } catch {
            
        }
        loadingCategoryItems = false
    }
    
    func loadItemModifierGroups (itemId: Int) async -> [ModifierGroup] {
        do {
            return try await networkService.apiCall(
                route: "/\(itemId)/modifiers",
                responseType: [ModifierGroup].self
            )
        } catch {
            return []
        }
    }
}
