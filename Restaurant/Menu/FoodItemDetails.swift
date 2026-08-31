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
    private let cartItemID: UUID?
    var foodItem: FoodMenuItem
    ///View States
    @State private var modifiers: [ModifierGroup] = []
    @State var itemImageUrl:URL? = nil
    @State private var quantity: Int
    @State private var selectedModifiers: [String: Modifier]
    
    private var modifierSelectionsAreValid: Bool {
        modifiers.allSatisfy { group in
            let count = selectedCount(in: group)
            let meetsMinimum = count >= group.minRequired
            let meetsMaximum = group.maxAllowed.map {
                $0 <= 0 || count <= $0
            } ?? true
            return meetsMinimum && meetsMaximum
        }
    }
    
    ///Initiation for Add To Cart View
    init(foodItem: FoodMenuItem) {
        self.foodItem = foodItem
        self.cartItemID = nil
        _quantity = State(initialValue: 1)
        _selectedModifiers = State(initialValue: [:])
    }
    ///Initiation for Edit Cart Item View
    init(cartItem: CartItem) {
        self.foodItem = cartItem.foodItem
        self.cartItemID = cartItem.id
        _quantity = State(initialValue: cartItem.quantity)
        _selectedModifiers = State(initialValue: cartItem.selectedModifiers)
    }
    
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
                                        ModifierRow(modi, group: modifier)
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
                    if let cartItemID {
                        cartVM.updateCartItem(
                            id: cartItemID,
                            quantity: quantity,
                            modifiers: selectedModifiers
                        )
                    } else {
                        cartVM.addToCart(
                            item: foodItem,
                            quantity: quantity,
                            modifiers: selectedModifiers
                        )
                    }
                    
                    dismiss()
                } label: {
                    Text(cartItemID == nil ? "Add to Cart" : "Update Cart")
                        .font(.inter(16, weight: .semibold))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity)
                        .background(.accent,in: RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
                .disabled(!modifierSelectionsAreValid)
                .opacity(modifierSelectionsAreValid ? 1 : 0.5)

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
    
    private func selectedCount(in group: ModifierGroup) -> Int {
        group.modifiers.reduce(0) { count, modifier in
            count + (selectedModifiers[modifier.posModifierId] == nil ? 0 : 1)
        }
    }
    
    private func toggle(_ modifier: Modifier, in group: ModifierGroup) {
        let key = modifier.posModifierId
        let count = selectedCount(in: group)
        if selectedModifiers[key] != nil {
            // Don’t go below the required minimum once reached.
            guard count < group.minRequired ||
                  count - 1 >= group.minRequired else { return }
            selectedModifiers.removeValue(forKey: key)
            return
        }
        if let maximum = group.maxAllowed, maximum > 0 {
            if maximum == 1 {
                // Single-choice group: replace the previous selection.
                group.modifiers.forEach {
                    selectedModifiers.removeValue(forKey: $0.posModifierId)
                }
            } else {
                guard count < maximum else { return }
            }
        }
        selectedModifiers[key] = modifier
    }
    
    @ViewBuilder
    func ModifierRow(
        _ modi: Modifier,
        group: ModifierGroup,
    ) -> some View {
        HStack {
            Text(modi.name)
                .font(.inter(14, weight: .semibold))
                .padding(.horizontal)
                .padding(.vertical)
            Spacer()
//            if isCheckMark {
                Button {
                    toggle(modi, in: group)
                } label: {
                    Image(
                        systemName: selectedModifiers[modi.posModifierId] != nil
                            ? "checkmark.square.fill"
                            : "square"
                    )
                    .font(.system(size: 22))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Select \(modi.name)")
                .padding(.trailing)
//            } else {
//                HStack(spacing: 16) {
//                    Button {
//                        print("sf")
//                    } label: {
//                        Image(systemName: "minus")
//                            .font(.system(size: 14))
//                            .frame(width: 20, height: 20)
//                            .contentShape(Rectangle())
//                    }
//                    .buttonStyle(.plain)
//                    .background {
//                        RoundedRectangle(cornerRadius: 4)
//                            .fill(.accent)
//                            .stroke(.border, lineWidth: 1)
//                    }
//                    
//                    Text("0")
//                        .font(.inter(14, weight: .semibold))
//                    
//                    Button {
//                        print("sf")
//                    } label: {
//                        Image(systemName: "plus")
//                            .font(.system(size: 14))
//                            .frame(width: 25, height: 25)
//                            .contentShape(Rectangle())
//                    }
//                    .buttonStyle(.plain)
//                    .background {
//                        RoundedRectangle(cornerRadius: 4)
//                            .fill(.accent)
//                            .stroke(.border, lineWidth: 1)
//                    }
//                }
//                .padding(.horizontal)
//            }
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

//#Preview {
//    @Previewable var item = FoodMenuItem.mock
//    NavigationStack {
//        NavigationLink {
//            FoodItemDetails(foodItem: item)
//        } label: {
//            Text(item.name)
//        }
//    }
//    .environment(MenuVM())
//    .environment(CartVM())
//}
