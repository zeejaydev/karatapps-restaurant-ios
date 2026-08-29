//
//  FoodItemDetails.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/22/26.
//

import SwiftUI
import Kingfisher

struct FoodItemDetails: View {
    @Environment(MenuVM.self) var menuVM
    @Environment(CartVM.self) var cartVM
    @Environment(\.dismiss) private var dismiss
    var foodItem: FoodMenuItem
    ///View States
    @State private var quantity: Int = 1
    @State private var modifiers: [ModifierGroup] = []
    @State var itemImageUrl:URL? = nil
    @State var selectedModifiers: [String:Modifier] = [:]
    
    var body: some View {
        VStack {
            ///Image
            if let url = itemImageUrl {
                VStack(alignment: .leading, spacing: 10) {
                    KFImage(url)
                        .resizable()
                        .scaledToFill()
                }
                .frame(maxWidth: .infinity, minHeight: 260, maxHeight: 260)
                .background {
                    VStack(spacing: 12) {
                        Image(systemName: "photo")
                        Text("No image Available")
                            .font(.caption)
                    }
                }
            }
            VStack(alignment: .leading, spacing: 20) {
                ///Item info
                VStack(alignment: .leading,spacing: 8) {
                    HStack {
                        Text(foodItem.name)
                            .font(.bricolage(28))
                        Spacer()
                        Text((foodItem.price/100).formatted(.currency(code: "USD")))
                            .font(.bricolage(24))
                    }
                    
                    if let description = foodItem.description, !description.isEmpty {
                        Text(description)
                            .font(.inter(14))
                            .foregroundStyle(.placeholder)
                    }
                }
                
                ///Quantity
                HStack(alignment: .center) {
                    Button {
                        guard quantity > 1 else { return }
                        quantity = quantity - 1
                    } label: {
                        Image(systemName: "minus")
                            .frame(width: 40, height: 40)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.surfaceElevated)
                            .stroke(.border, lineWidth: 1)
                    }

                    Spacer()
                    Text("\(quantity)")
                        .font(.bricolage(32))
                    Spacer()
                    Button {
                        guard quantity < 15 else { return }
                        quantity = quantity + 1
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 40, height: 40)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.surfaceElevated)
                            .stroke(.border, lineWidth: 1)
                    }
                }
                
                ///Modifiers
                if !modifiers.isEmpty {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(modifiers) { modifier in
                                HStack(alignment:.center) {
                                    Text(modifier.modifierGroupName)
                                        .font(Font.bricolage(16, weight: .semibold))
                                    
                                    Spacer()
                                    
                                    HStack(alignment: .center, spacing: 10) {
                                        if modifier.minRequired > 0 {
                                            Text("Min Required \(modifier.minRequired)")
                                                .font(.inter(11))
                                        }
                                        if let maxAllowed = modifier.maxAllowed, maxAllowed > 0 {
                                            Text("Max Allowed \(maxAllowed)")
                                                .font(.inter(11))
                                        }
                                    }
                                }
                                
                                LazyVStack(alignment: .leading, spacing: 10) {
                                    ForEach(modifier.modifiers) { modi in
                                        ModifierRow(
                                            modi,
                                            isCheckMark: modifier.minRequired == 0 && modifier.maxAllowed == nil
                                        )
                                        .background {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(.surfaceElevated)
                                                .stroke(.border, lineWidth: 1)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    Spacer()
                }
                
                Button {
                    cartVM.addToCart(
                        item: foodItem,
                        quantity: quantity,
                        modifiers: selectedModifiers
                    )
                    dismiss()
                } label: {
                    Text("Add to Cart")
                        .font(.inter(16, weight: .semibold))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity)
                        .background(.accent,in: RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)

            }
            .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
            .safeAreaPadding(.horizontal)
            .padding(.vertical)
        }
        .ignoresSafeArea(edges: itemImageUrl != nil ? [ .top ] : [])
        .task {
            itemImageUrl = URL(string: foodItem.images.first?.url ?? "")
            modifiers = await menuVM.loadItemModifierGroups(itemId: foodItem.id)
        }
    }
    
    @ViewBuilder
    func ModifierRow(
        _ modi: Modifier,
        isCheckMark: Bool = false
    ) -> some View {
        HStack {
            Text(modi.name)
                .font(.inter(14, weight: .semibold))
                .padding(.horizontal)
                .padding(.vertical)
            Spacer()
            if isCheckMark {
                Toggle(isOn: selectionBinding(for: modi)) {
                    Image(
                        systemName: selectedModifiers[modi.posModifierId] != nil
                            ? "checkmark.square.fill"
                            : "square"
                    )
                    .font(.system(size: 22))
                }
                .toggleStyle(.button)
                .buttonStyle(.plain)
                .accessibilityLabel("Select \(modi.name)")
                .padding(.trailing)
            } else {
                HStack(spacing: 16) {
                    Button {
                        print("sf")
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 14))
                            .frame(width: 20, height: 20)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.accent)
                            .stroke(.border, lineWidth: 1)
                    }
                    
                    Text("0")
                        .font(.inter(14, weight: .semibold))
                    
                    Button {
                        print("sf")
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 14))
                            .frame(width: 25, height: 25)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.accent)
                            .stroke(.border, lineWidth: 1)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func selectionBinding(
        for modifier: Modifier
    ) -> Binding<Bool> {
        Binding(
            get: {
                selectedModifiers[modifier.posModifierId] != nil
            },
            set: { isSelected in
                if isSelected {
                    selectedModifiers[modifier.posModifierId] = modifier
                } else {
                    selectedModifiers.removeValue(forKey: modifier.posModifierId)
                }
            }
        )
    }
}

#Preview {
    ZStack {
        Color.BG.ignoresSafeArea()
        FoodItemDetails(foodItem: FoodMenuItem.mock)
            .environment(MenuVM())
            .environment(CartVM())
    }
}

#Preview {
    @Previewable var item = FoodMenuItem.mock
    NavigationStack {
        NavigationLink {
            FoodItemDetails(foodItem: item)
        } label: {
            Text(item.name)
        }
    }
    .environment(MenuVM())
    .environment(CartVM())
}
