//
//  Order.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/21/26.
//

import Foundation

struct OrderType: Codable {
    let id, brandLocationId, avgOrderTime, fee: Int
    let label, cloverId: String
    let taxable: Bool
}

struct OrderPayload: Codable {
    let items: [OrderPayloadItem]
    let orderTypeId: String
    
    struct OrderPayloadItem: Codable {
        let id: String
        let modifiers: [Modifier]
    }
    
    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}

struct PlaceOderPayload: Codable {
    let items: [OrderPayload.OrderPayloadItem]
    let orderTypeId, sourceToken: String
    let tipAmount: Int
    let customer: CustomerInfo
    
    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}

struct PlaceOrderResp: Codable {
    let order: OrderResp
    let payment: PaymentResp
}

// MARK: - OrderResp
struct OrderResp: Codable {
//    let href: String
    let id, currency: String
//    let employee: Employee
    let total: Int
    let title, note: String
//    let orderType: OrderType
    let taxRemoved, isVat: Bool
    let state: String
    let manualTransaction, groupLineItems, testMode: Bool
    let createdTime, clientCreatedTime, modifiedTime: Int
//    let lineItems: LineItems
}

struct PaymentResp: Codable {
    let id, object: String
    let amount, taxAmount, amountPaid, taxAmountPaid: Int
    let currency, charge: String
    let created: Int
    let refNum, authCode: String
//    let items: [Item]
//    let source: Source
    let status: String
//    let statusTransitions: StatusTransitions
    let ecomind: String

    enum CodingKeys: String, CodingKey {
        case id, object, amount, taxAmount, amountPaid, taxAmountPaid
        case currency, charge, created, refNum, authCode, status, ecomind
//        case statusTransitions = "status_transitions"
    }
}

struct OrderConfirmation: Identifiable, Equatable {
    let paymentId: String
    let orderId: String
    
    var id: String { self.paymentId }
}
