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
    var selectedLocation: RestaurantLocation? = nil
    
    func load() async {
        ///Get locations
        do {
            locations = try await netwrokService.apiCall(
                method: .get,
                route: "/locations",
                responseType: [RestaurantLocation].self
            )
            
            selectedLocation = locations.first
            
            ///Get menu categories for location
            if let locationId = selectedLocation?.posLocationId {
                menuCategories = try await netwrokService.apiCall(
                    method: .get,
                    route: "/\(locationId)/categories",
                    responseType: [FoodMenuCategory].self
                ).sorted { $0.sortOrder < $1.sortOrder }
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
                    heroImageUrl: "https://olo-images-live.imgix.net/c9/c9f0c54177cd46aa98b8b6a827beee89.png?auto=format%2Ccompress&q=60&cs=tinysrgb&w=1200&h=800&fit=fill&fm=png32&bg=transparent&s=7191284232c6183463f8a207b99eefa1",
                    recentOrders: [],
                    rewards: [],
                    promo: HomeData.Promo(
                        title: "20% OFF",
                        description: "Regular Teriyaki Chicken & Katsu Chicken",
                        imageUrl: "https://olo-images-live.imgix.net/b3/b3b22223be7744bf97f9345f4fa0a058.png?auto=format%2Ccompress&q=60&cs=tinysrgb&w=1200&h=800&fit=fill&fm=png32&bg=transparent&s=2d197603c81b30290cb455adb586bc9f",
                        promoCode: "TERI26"
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
            heroImageUrl: "https://olo-images-live.imgix.net/c9/c9f0c54177cd46aa98b8b6a827beee89.png?auto=format%2Ccompress&q=60&cs=tinysrgb&w=1200&h=800&fit=fill&fm=png32&bg=transparent&s=7191284232c6183463f8a207b99eefa1",
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
                description: "Regular Teriyaki Chicken & Katsu Chicken",
                imageUrl: "https://olo-images-live.imgix.net/b3/b3b22223be7744bf97f9345f4fa0a058.png?auto=format%2Ccompress&q=60&cs=tinysrgb&w=1200&h=800&fit=fill&fm=png32&bg=transparent&s=2d197603c81b30290cb455adb586bc9f",
                promoCode: "TERI26"
            ),
        )
    }
}
