//
//  Menu.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/17/26.
//

import SwiftUI
import Kingfisher

struct Menu: View {
    @Environment(AppVM.self) var appVM
    @Environment(CartVM.self) var cartVM
    @State private var menuVM: MenuVM = MenuVM()
    @State private var selectedCategory: Int? = nil
    @Namespace private var animation
    
    private let gridCols: [GridItem] = [
        GridItem(.flexible(), spacing: 12, alignment: .top),
        GridItem(.flexible(), spacing: 0, alignment: .top)
    ]
    
    var body: some View {
        VStack {
            ///Header
            VStack(spacing: 4) {
                ///Location
                HStack(alignment: .center) {
                    Image(.locationPin)
                        .resizable()
                        .frame(width: 24, height: 25)
                    Button {
                        print("loc")
                    } label: {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Ordering from")
                                .font(.inter(14, weight: .semibold))
                            HStack(spacing: 10) {
                                Text("South Jordan")
                                    .font(.inter(18, weight: .semibold))
                                Image(systemName: "chevron.down")
                            }
                        }
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    NavigationLink {
                        CartView()
                            .environment(menuVM)
                            .environment(cartVM)
                    } label: {
                        Image(systemName: "cart")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .overlay(alignment: .topTrailing) {
                                if cartVM.itemsCount > 0 {
                                    Text(cartVM.itemsCount, format: .number)
                                        .font(.inter(11, weight: .bold))
                                        .foregroundStyle(.white)
                                        .padding(6)
                                        .background(.red, in: Circle())
                                        .offset(x: 6, y: -10)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    .navigationTitle("Your Order")
                }
                ///Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(appVM.menuCategories) { cat in
                            CategoryButton(cat)
                        }
                    }
                }
                .frame(height: 50)
            }
            .safeAreaPadding(.horizontal, 15)
            ///Menu
            if menuVM.loadingCategoryItems {
                Spacer()
                ProgressView()
                Spacer()
            } else if menuVM.categoryItems.isEmpty && !menuVM.loadingCategoryItems {
                Spacer()
                Text("No items")
                Spacer()
            } else {
                ScrollView(.vertical) {
                    LazyVGrid(columns: gridCols) {
                        if let selectedCat = selectedCategory,
                           let items = menuVM.categoryItems[selectedCat] {
                            ForEach(items) { item in
                                NavigationLink {
                                    FoodItemDetails(foodItem: item)
                                        .environment(menuVM)
                                } label: {
                                    FoodItemCard(item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .safeAreaPadding(.horizontal)
                }
            }
        }
        .onAppear {
            print("\(appVM.menuCategories.count)")
            selectedCategory = appVM.menuCategories.first?.id
        }
        .onChange(of: selectedCategory) { _ , newValue in
            if let catId = newValue {
                Task {
                    await menuVM.loadCategoryItems(categoryId: catId)
                }
            }
        }
    }
    
    @ViewBuilder
    private func CategoryButton(_ category: FoodMenuCategory) -> some View {
        Button {
            withAnimation(.snappy) {
                selectedCategory = category.id
            }
        } label: {
            Text(category.name)
                .font(.inter(14, weight: .bold))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .foregroundStyle(selectedCategory == category.id ? .black : .primary)
        }
        .buttonStyle(.plain)
        .background {
            if selectedCategory == category.id {
                Capsule()
                    .fill(.brandPrimary)
                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    .shadow(radius: 1)
            } else {
                Capsule()
                    .fill(.surfaceElevated)
                    .strokeBorder(.border,lineWidth: 1)
            }
        }
    }
    
    @ViewBuilder
    private func FoodItemCard(_ item: FoodMenuItem) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageURL = item.images.first?.url {
                KFImage(URL(string: imageURL))
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .clipped()
            }
            
            Text(item.name)
                .font(.inter(16, weight: .semibold))
            
            if let description = item.description, !description.isEmpty {
                Text(description)
                    .font(.inter(13))
                    .foregroundStyle(.secondary)
            }
            
            Text((item.price/100).formatted(.currency(code: "USD")))
                .font(.inter(16, weight: .semibold))
        }
        .padding(12)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
        .background(.surface, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    @Previewable @State var activeTab: AppTabs = .menu
    @Previewable @State var appVM: AppVM = .init()
    @Previewable @State var cartVM: CartVM = .init()
    

    TabView(selection: $activeTab) {
        Tab.init(value: .home) {
            NavigationStack {
                ZStack {
                    Color.BG.ignoresSafeArea()
                    Home(viewModel: HomeVM(), activeTab: $activeTab)
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
                        .toolbar(.hidden, for: .navigationBar)
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
    .environment(cartVM)
    .task {
        await appVM.load()
    }
}
