//
//  Home.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/9/26.
//

import SwiftUI
import Kingfisher

struct Home: View {
    @Environment(AppVM.self) var appVM: AppVM
    @State var viewModel: HomeVM
    
    var body: some View {
        Group {
            if let homeData = appVM.homeData {
                ScrollView(.vertical, showsIndicators: false) {
                    KFImage(URL(string:homeData.heroImageUrl))
                    .placeholder {
                        ProgressView()
                    }
                    .cacheMemoryOnly()
                    .resizable()
                    .frame(maxWidth: .infinity,minHeight: 280, maxHeight: 280)
                    
                    VStack(alignment: .leading, spacing: 30) {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Creaving Something Delicious?")
                                .font(.inter(30, weight: .heavy))
                                
                            
                            Button("Order Now") {
                                print("test")
                            }
                            .buttonStyle(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        if let promo = homeData.promo {
                            PromoCardView(promo: promo)
                        }
                        
                        if homeData.recentOrders.isEmpty {
                            HStack {
                                Text("No recent orders")
                                    .font(.inter(14, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            RecentOrdersSection(homeData.recentOrders)
                        }
                        
                        RewardsSection(homeData.rewards)
                    }
                }
                .ignoresSafeArea(edges: .top)
            } else {
                Text("Sorry for the inconvenience, we are currently under maintenance")
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    fileprivate func PromoCardView(promo: HomeData.Promo) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Promo")
                .font(.inter(18, weight: .bold))
            HStack(spacing: 12) {
                VStack(alignment: .leading) {
                    Text(promo.title)
                        .font(.inter(24, weight: .heavy))
                        .foregroundStyle(.black)
                    Text(promo.description)
                        .foregroundStyle(.black)
                        .font(.inter(14, weight:.semibold))
                    Text(promo.promoCode.uppercased())
                        .foregroundStyle(.brandPrimary)
                        .font(.inter(12, weight: .bold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.black, in: .capsule)
                }
                .padding()
                
                Spacer()
                
                KFImage(
                    URL(string: promo.imageUrl)
                )
                .cacheMemoryOnly()
                .resizable()
                .clipShape(UnevenRoundedRectangle(bottomTrailingRadius: 16,topTrailingRadius: 16))
                .scaledToFit()
                
            }
            .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 140)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.brandPrimary)
                    .shadow(radius: 1)
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    fileprivate func RecentOrdersSection(_ recentOrders: [HomeData.RecentOrderCard]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Orders")
                .font(.inter(18, weight: .bold))
                .padding(.leading)
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(recentOrders) { order in
                        VStack(spacing: 0) {
                            KFImage(URL(string: order.imageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 260, height: 140)
                                .clipped()
                                .clipShape(
                                    UnevenRoundedRectangle(
                                        topLeadingRadius: 16,
                                        topTrailingRadius: 16
                                    )
                                )
                            
                            VStack(alignment: .leading) {
                                Text(order.title)
                                    .font(.inter(16, weight: .semibold))
                                Text(order.title)
                                    .font(.inter(13))
                                    .foregroundStyle(.placeholder)
                                Text(order.total / 100, format: .currency(code: "USD"))
                                    .font(.inter(13, weight: .semibold))
                                    .padding(.top, 4)
                            }
                            .padding()
                            .frame(maxWidth: 260, alignment: .leading)

                        }
                        .frame(width: 260)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.surface)
                                .shadow(radius: 1)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
    }
    
    @ViewBuilder
    fileprivate func RewardsSection(_ rewards: [HomeData.RewardCard]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Rewards")
                .font(.inter(18, weight: .bold))
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(rewards, id: \.id) { reward in
                        VStack {
                            KFImage(URL(string: reward.imageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 260, height: 72)
                                .clipped()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(reward.title)
                                    .font(.inter(16, weight: .semibold))
                                
                                Text(reward.description)
                                    .font(.inter(13))
                                    .foregroundStyle(.placeholder)
                                
                                ProgressView(value: 60, total: 100)
                                    .tint(.brandPrimary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.surface)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 1)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    @Previewable @State var appVM: AppVM = AppVM()
    @Previewable @State var activeTab: AppTabs = .home
    
    appVM.homeData = .mock
    
    return TabView(selection: $activeTab) {
        Tab.init(value: .home) {
            NavigationStack {
                ZStack {
                    Color.BG.ignoresSafeArea()
                    Home(viewModel: HomeVM())
                }
            }
        } label: {
            Image(systemName: AppTabs.home.symbol)
        }
        Tab.init(value: .menu) {
            NavigationStack{
                ZStack {
                    Color.BG.ignoresSafeArea()
                    Menu()
                }
            }
        } label: {
            Image(systemName: AppTabs.menu.symbol)
        }
        
        Tab(value: .orders) {
            NavigationStack{
                ZStack{
                    Color.BG.ignoresSafeArea()
                    Text("Orders")
                }
            }
        } label: {
            Image(systemName: AppTabs.orders.symbol)
        }
        
        Tab(value: .profile) {
            NavigationStack {
                ZStack {
                    Color.BG.ignoresSafeArea()
                    Text("Profile")
                }
            }
        } label: {
            Image(systemName: AppTabs.profile.symbol)
        }
    }
    .environment(appVM)
}
