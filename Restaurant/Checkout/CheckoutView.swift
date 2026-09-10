//
//  CheckoutView.swift
//  Restaurant
//
//  Created by Zaid Jamil on 9/5/26.
//

import SwiftUI

enum Field {
    case firstName
    case lastName
    case email
    case phoneNumber
    case address
    case tip
}

enum Tip: String, CaseIterable, Identifiable {
    case tip10 = "18%"
    case tip15 = "20%"
    case tip20 = "25%"
    case custom = "Custom"
    
    var id : String {
        self.rawValue
    }
}
struct CheckoutView: View {
    @Environment(AppVM.self) private var appVM
    @Environment(CartVM.self) private var cartVM
    @State private var customer: CustomerInfo = .init(
        firstName: "", lastName: "", email: "", phoneNumber: "", address: ""
    )
    @FocusState private var focusedField: Field?
    @State var cards: [CloverCardResult.CloverCard] = []
    @State var cardToken: String?
    @State var tip: Tip = .tip15
    @State var customTip: String = ""
    @State var orderConfirmation: OrderConfirmation? = nil
    
    var totalTip: Double {
        print(customTip)
        switch tip {
        case .tip10: return (cartVM.total.subtotal / 100) * 0.1
        case .tip15: return (cartVM.total.subtotal / 100) * 0.15
        case .tip20: return (cartVM.total.subtotal / 100) * 0.2
        case .custom: return Double(customTip.replacingOccurrences(of: "$", with: "")) ?? 0
        }
    }
    
    var isReadyToPay: Bool {
        !customer.firstName.isEmpty &&
        !customer.lastName.isEmpty &&
        !customer.email.isEmpty &&
        !customer.phoneNumber.isEmpty &&
        !customer.address.isEmpty
    }
    
    var body: some View {
        return ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ///Contact Info
                ContactInfo()
                
                ///Payment Methods
                PaymentMethod()
                
                ///Tip Segmented Picker
                TipView()
                
                ///Total
                TotalView()
                
                ///Place Order Button
                Button {
                    guard let cardToken else { return }
                    Task {
                        await cartVM.placeOrder(
                            cardToken: cardToken,
                            tip: Int(totalTip * 100),
                            customerInfo: customer
                        )
                    }
                } label: {
                    Text(cartVM.orderConfirmation != nil ? "Order Placed" : "Place Order")
                }
                .buttonStyle(.primary)
                .disabled(
                    cardToken == nil ||
                    !isReadyToPay ||
                    cartVM.placingOrder ||
                    cartVM.orderConfirmation != nil
                )
                .opacity(
                    cardToken == nil ||
                    !isReadyToPay ||
                    cartVM.placingOrder ||
                    cartVM.orderConfirmation != nil ? 0.5 : 1)
            }
            .safeAreaPadding()
        }
        .scrollDismissesKeyboard(.immediately)
        .onTapGesture {
            focusedField = nil
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button {
                    focusedField = nil
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
        .onChange(of: tip) { oldValue, ـ in
            if oldValue == Tip.custom {
                customTip = ""
            }
        }
        .onChange(of: cartVM.orderConfirmation) { _, newValue in
            orderConfirmation = newValue
        }
        .fullScreenCover(item: $orderConfirmation) { confirmation in
            ZStack {
                Color.BG.ignoresSafeArea()
                OrderConfirmationView()
            }
        }
    }
    
    @ViewBuilder
    func ContactInfo () -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Contact Information".capitalized)
                .font(.inter(14, weight: .semibold))
            
            TextField("First Name", text: $customer.firstName)
                .font(.inter(14, weight: .semibold))
                .padding(.vertical, 10)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(.separator)
                        .frame(height: 1)
                }
                .focused($focusedField, equals: .firstName)
                .submitLabel(.next)
                .autocorrectionDisabled(true)
            
            TextField("Last Name", text: $customer.lastName)
                .font(.inter(14, weight: .semibold))
                .padding(.vertical, 10)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(.separator)
                        .frame(height: 1)
                }
                .focused($focusedField, equals: .lastName)
                .submitLabel(.next)
                .autocorrectionDisabled(true)
            
            TextField("Email", text: $customer.email)
                .font(.inter(14, weight: .semibold))
                .keyboardType(.emailAddress)
                .padding(.vertical, 10)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(.separator)
                        .frame(height: 1)
                }
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .autocorrectionDisabled(true)
            
            TextField("Phone", text: $customer.phoneNumber)
                .font(.inter(14, weight: .semibold))
                .keyboardType(.phonePad)
                .padding(.vertical, 10)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(.separator)
                        .frame(height: 1)
                }
                .focused($focusedField, equals: .phoneNumber)
                .submitLabel(.next)
                .onChange(of: customer.phoneNumber) { oldValue, newValue in
                    let formatted = PhoneFormatter.format(newValue)
                    if formatted != newValue { customer.phoneNumber = formatted }
                }
            
            TextField("Address", text: $customer.address)
                .font(.inter(14, weight: .semibold))
                .padding(.vertical, 10)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(.separator)
                        .frame(height: 1)
                }
                .focused($focusedField, equals: .address)
                .submitLabel(.done)

        }
        .onSubmit {
            switch focusedField {
            case .firstName:
                focusedField = .lastName
            case .lastName:
                focusedField = .email
            case .email:
                focusedField = .phoneNumber
            case .phoneNumber:
                focusedField = .address
            default:
                focusedField = nil
            }
        }
        .padding(16)
        .background(.surface,in: RoundedRectangle(cornerRadius: 8))
    }
    
    @ViewBuilder
    func PaymentMethod() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Methods")
                .font(.inter(14, weight: .semibold))
            
            if cards.isEmpty {
                NavigationLink {
                    print(Configuration.pakms_key, appVM.selectedLocation?.posLocationId ?? "")
                    return CloverCheckoutView(
                        apiAccessKey: Configuration.pakms_key,
                        locationId: appVM.selectedLocation?.posLocationId ?? "",
                        cards: $cards,
                        token: $cardToken
                    )
                } label: {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundStyle(.placeholder)
                        Text("Add New Payment Method")
                            .font(.inter(16, weight: .semibold))
                            .foregroundStyle(.placeholder)
                        Spacer()
                        Image(systemName: "creditcard")
                            .foregroundStyle(.placeholder)
                    }
                }
                .buttonStyle(.plain)
                .padding(.vertical, 10)
                .disabled(appVM.selectedLocation?.posLocationId == nil)
            } else {
                CardsView()
            }
        }
        .padding(16)
        .background(.surface,in: RoundedRectangle(cornerRadius: 8))
    }
    
    @ViewBuilder
    func CardsView() -> some View {
        ForEach(cards) { card in
            HStack(spacing: 12) {
                Text(card.brand)
                    .font(Font.inter(.init(12), weight: .bold))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(.surfaceElevated,in: RoundedRectangle(cornerRadius: 6))
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(card.brand.capitalized) ending in \(card.last4)")
                        .font(Font.inter(.init(15), weight: .semibold))
                    Text("Expiers \(card.exp_month)/\(card.exp_year)")
                        .font(Font.inter(.init(12)))
                        .foregroundStyle(.placeholder)
                }
                Spacer()
                Button {
                    cards = []
                    cardToken = nil
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.red)
                }
            }
        }
    }
    
    @ViewBuilder
    func TipView() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Add tip")
                .font(.inter(14, weight: .semibold))
            Picker("", selection: $tip) {
                ForEach(Tip.allCases, id: \.self) { tip in
                    Text(tip.rawValue)
                        .font(Font.inter(16, weight: .bold))
                        .tag(tip)
                }
            }
            .pickerStyle(.segmented)
            .controlSize(.small)
            
            if tip == .custom {
                TextField("Tip amount", text: $customTip)
                    .keyboardType(.numberPad)
                    .onChange(of: customTip) { _, newValue in
                        let masked = CurrencyMask.maskedCurrency(newValue)
                        if masked != newValue { customTip = masked }
                    }
                    .font(.inter(14, weight: .semibold))
                    .padding(.vertical, 10)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.separator)
                            .frame(height: 1)
                    }
                    .focused($focusedField, equals: .tip)
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.surface)
                .stroke(.border, lineWidth: 1)
        }
        .onAppear {
            // Style the text for the NORMAL (unselected) state
            UISegmentedControl.appearance().setTitleTextAttributes([
                .foregroundColor: UIColor.systemGray,
                .font: UIFont.systemFont(ofSize: 12, weight: .regular)
            ], for: .normal)
            
            // Style the text for the SELECTED state
            UISegmentedControl.appearance().setTitleTextAttributes([
                .foregroundColor: UIColor.darkText,
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
            ], for: .selected)
            
            // Style the background / slider tint color
            UISegmentedControl.appearance().selectedSegmentTintColor = .brandPrimary
        }
    }
    
    @ViewBuilder
    func TotalView() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack{
                Text("Subtotal")
                    .font(.inter(14))
                    .foregroundStyle(.placeholder)
                Spacer()
                Text((Decimal(cartVM.total.subtotal) / 100), format: .currency(code: "USD"))
                    .font(.inter(14, weight: .medium))
            }
            HStack{
                Text("Tax")
                    .font(.inter(14))
                    .foregroundStyle(.placeholder)
                Spacer()
                Text((Decimal(cartVM.total.tax) / 100), format: .currency(code: "USD"))
                    .font(.inter(14, weight: .medium))
            }
            HStack{
                Text("Tip")
                    .font(.inter(14))
                    .foregroundStyle(.placeholder)
                Spacer()
                Text(totalTip, format: .currency(code: "USD"))
                    .font(.inter(14, weight: .medium))
            }
            Divider()
            HStack{
                Text("Total")
                    .font(.inter(16, weight: .semibold))
                
                Spacer()
                
                Text(((Decimal(cartVM.total.total) / 100) + Decimal(totalTip)), format: .currency(code: "USD"))
                    .font(.bricolage(20, weight: .bold))
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.surface)
                .stroke(.border, lineWidth: 1)
        }
    }
}

#Preview {
    @Previewable var appVM: AppVM = AppVM()
    @Previewable var cartVM: CartVM = CartVM()
    NavigationStack {
        ZStack {
            Color.BG.ignoresSafeArea()
            CheckoutView()
                .environment(appVM)
                .environment(cartVM)
        }
    }
    .task {
        await appVM.load()
    }
}
