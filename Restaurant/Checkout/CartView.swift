//
//  CartView.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/29/26.
//

import SwiftUI
import Kingfisher

struct CartView: View {
    @Environment(CartVM.self) private var cartVM
    @Environment(MenuVM.self) private var menuVM
    ///View States
    @State private var selectedItemId: UUID?
    var subTotal: Int {
        return cartVM.cart.reduce(0) { partialResult, cartItem in
            partialResult + (cartItem.foodItem.price * cartItem.quantity)
        }
    }
    var tax : Int = 454
    
    var body: some View {
        if cartVM.cart.isEmpty {
            HStack {
                Spacer()
                Text("Your cart is empty")
                Spacer()
            }
            .padding(.vertical, 12)
        } else {
            VStack(spacing: 16) {
                /// Location
                HStack(alignment: .center, spacing: 12) {
                    Image(.locationPin)
                        .resizable()
                        .frame(width: 20, height: 20)
                    Button {
                        print("loc")
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Ordering from")
                                .font(.inter(12))
                                .foregroundStyle(.placeholder)
                            HStack(spacing: 10) {
                                Text("South Jordan")
                                    .font(.inter(14, weight: .semibold))
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button {
                        print("change")
                    } label: {
                        Text("Change")
                            .font(.inter(14, weight: .semibold))
                    }
                    .buttonStyle(.plain)
                    
                }
                .padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.surfaceElevated)
                        .stroke(.border, lineWidth: 1)
                }
                
                ///Cart Items
                List {
                    ForEach(cartVM.cart) { item in
                        CartItemRow(for: item)
                    }
                    .onDelete { indexSet in
                        cartVM.removeFromCart(atOffsets: indexSet)
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .navigationDestination(item: $selectedItemId) { id in
                    if let item = cartVM.cart.first(where: { $0.id == id }) {
                        FoodItemDetails(cartItem: item)
                            .environment(menuVM)
                            .environment(cartVM)
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.surfaceElevated)
                        .stroke(.border, lineWidth: 1)
                }
                ///Total
                VStack(alignment: .leading, spacing: 16) {
                    HStack{
                        Text("Subtotal")
                            .font(.inter(14))
                            .foregroundStyle(.placeholder)
                        Spacer()
                        Text((Decimal(subTotal) / 100), format: .currency(code: "USD"))
                            .font(.inter(14, weight: .medium))
                    }
                    HStack{
                        Text("Tax")
                            .font(.inter(14))
                            .foregroundStyle(.placeholder)
                        Spacer()
                        Text((Decimal(tax) / 100), format: .currency(code: "USD"))
                            .font(.inter(14, weight: .medium))
                    }
                    Divider()
                    HStack{
                        Text("Total")
                            .font(.inter(16, weight: .semibold))
                        
                        Spacer()
                        
                        Text((Decimal(subTotal + tax) / 100), format: .currency(code: "USD"))
                            .font(.bricolage(20, weight: .bold))
                    }
                }
                .padding(20)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.surfaceElevated)
                        .stroke(.border, lineWidth: 1)
                }
                
                Button("Checkout".uppercased()) {
                    print("test")
                }
                .buttonStyle(.primary)
            }
            .safeAreaPadding()
        }
    }
    
    @ViewBuilder
    func CartItemRow(for item: CartItem) -> some View {
        HStack(alignment: .top) {
            if let imgUrl = item.foodItem.images.first?.url,
               let url = URL(string: imgUrl) {
                KFImage(url)
                    .resizable()
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .scaledToFill()
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top, spacing: 2) {
                    Text(item.foodItem.name)
                        .font(.inter(14, weight: .semibold))
                }
                
                if let description = item.foodItem.description, !description.isEmpty {
                    Text(description)
                        .font(.inter(12))
                        .foregroundStyle(.placeholder)
                }
                ForEach(Array(item.selectedModifiers.values)) { modifier in
                    Text("+" + modifier.name)
                        .font(.inter(12))
                        .foregroundStyle(.placeholder.tertiary)
                }
            }
            
            Spacer()
            
            HStack{
                VStack(alignment: .trailing, spacing: 12) {
                    HStack(alignment: .top, spacing: 4){
                        Text("x\(item.quantity)")
                            .font(.inter(12))
                            .foregroundStyle(.placeholder)
                        Text((Decimal(item.foodItem.price) / 100), format: .currency(code: "USD"))
                            .font(.inter(14, weight: .semibold))
                    }
                    
                    Button {
                        selectedItemId = item.id
                    } label: {
                        Image(systemName: "pencil")
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable var cartVM: CartVM = CartVM()
    
    return NavigationStack {
        ZStack {
            Color.BG.ignoresSafeArea()
            CartView()
                .environment(MenuVM())
                .environment(cartVM)
        }
    }
    .onAppear {
        guard cartVM.cart.isEmpty else { return }
        cartVM.loadMockData()
    }
}
