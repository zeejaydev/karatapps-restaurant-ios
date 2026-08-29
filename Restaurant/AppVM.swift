//
//  AppVM.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/9/26.
//

import Foundation
import Observation

@MainActor
@Observable
public final class AppVM {
    let netwrokService: NetworkService = NetworkService.shared
    var user: Bool = false
    var phase: Phase = .loading
    var homeData: HomeData?
    var locations: [RestaurantLocation] = []
    var menuCategories: [FoodMenuCategory] = []
    
    func load() async {
        ///Get locations
        do {
            locations = try await netwrokService.apiCall(
                method: .get,
                route: "/locations",
                responseType: [RestaurantLocation].self
            )
            
            ///Get menu categories for location
            if let locationId = locations.first?.posLocationId {
                menuCategories = try await netwrokService.apiCall(
                    method: .get,
                    route: "/\(locationId)/categories",
                    responseType: [FoodMenuCategory].self
                ).filter { $0.id == 22 }
                
            }
        } catch {
            print(error)
            phase = .failed
            return
        }
        
        ///Get home data
        do {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.homeData = HomeData(
                    heroImageUrl: "https://images.unsplash.com/photo-1571091718767-18b5b1457add?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8YnVyZ2Vyc3xlbnwwfHwwfHx8MA%3D%3D",
                    recentOrders: [],
                    rewards: [],
                    promo: HomeData.Promo(
                        title: "20% OFF",
                        description: "All Pizzas",
                        imageUrl: "https://images.unsplash.com/photo-1700760934249-93efbb574d23?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        promoCode: "PIZ26"
                    ),
                )
                self.phase = .ready
            }
        } catch {
            print(error)
            phase = .failed
        }
    }
}

enum Phase {
    case loading
    case ready
    case failed
}

struct HomeData {
    var heroImageUrl: String
    var recentOrders: [RecentOrderCard]
    var rewards: [RewardCard]
    var promo: Promo? = nil
    
    struct Promo {
        var title, description, imageUrl, promoCode: String
    }
    
    struct RecentOrderCard: Identifiable {
        var id: Int
        var title, imageUrl: String
        var total: Int
    }
    
    struct RewardCard: Identifiable {
        var id: Int
        var title, description, imageUrl: String
        var progress: Int
    }
    
    static var mock: HomeData {
        HomeData(
            heroImageUrl: "https://images.unsplash.com/photo-1571091718767-18b5b1457add?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8YnVyZ2Vyc3xlbnwwfHwwfHx8MA%3D%3D",
            recentOrders: [
                RecentOrderCard(
                    id: 1,
                    title: "Margherita Pizza",
                    imageUrl: "https://images.unsplash.com/photo-1700760934249-93efbb574d23?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    total: 1400
                ),
                RecentOrderCard(
                    id: 2,
                    title: "Margherita Pizza",
                    imageUrl: "https://images.unsplash.com/photo-1700760934249-93efbb574d23?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    total: 1400
                ),
                RecentOrderCard(
                    id: 3,
                    title: "Margherita Pizza",
                    imageUrl: "https://images.unsplash.com/photo-1700760934249-93efbb574d23?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    total: 1400
                )
            ],
            rewards: [
                RewardCard(id: 1, title: "Free Drink", description: "60 pts (60/100)", imageUrl: "https://plus.unsplash.com/premium_photo-1680626371689-0f4efbbaf5e6?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", progress: 60),
                RewardCard(id: 2, title: "Free Drink", description: "60 pts (60/100)", imageUrl: "https://plus.unsplash.com/premium_photo-1680626371689-0f4efbbaf5e6?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", progress: 60),
                RewardCard(id: 3, title: "Free Drink", description: "60 pts (60/100)", imageUrl: "https://plus.unsplash.com/premium_photo-1680626371689-0f4efbbaf5e6?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", progress: 60),
            ],
            promo: HomeData.Promo(
                title: "20% OFF",
                description: "All Pizzas",
                imageUrl: "https://images.unsplash.com/photo-1700760934249-93efbb574d23?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                promoCode: "PIZ26"
            ),
        )
    }
}
