//
//  Extenstions.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/15/26.
//

import Foundation
import SwiftUI

extension Font {
    static let appDisplay  = Font.custom("BricolageGrotesque-Bold", size: 40, relativeTo: .largeTitle)
    static let appBody  = Font.custom("Inter18pt-Regular", size: 16, relativeTo: .body)
    
    static func inter(
        _ size: CGFloat = 17,
        weight: Font.Weight = .regular,
        releativeTo: Font.TextStyle = .body
    ) -> Font {
        let name: String
        switch weight {
        case .light: name = "Inter18pt-Light"
        case .bold: name = "Inter18pt-Bold"
        case .semibold: name = "Inter18pt-SemiBold"
        case .heavy: name = "Inter28pt-ExtraBold"
        default: name = "Inter18pt-Regular"
        }
        return .custom(name,size: size, relativeTo: releativeTo)
    }
    
    static func bricolage(
        _ size: CGFloat = 32,
        weight: Font.Weight = .bold,
        releativeTo: Font.TextStyle = .largeTitle
    ) -> Font {
        let name: String
        switch weight {
        case .black: name = "BricolageGrotesque72pt-ExtraBold"
        case .bold: name = "BricolageGrotesque-Bold"
        case .semibold: name = "BricolageGrotesque24pt-SemiBold"
        default: name = "BricolageGrotesque-Bold"
        }
        return .custom(name,size: size, relativeTo: releativeTo)
    }
}

struct PrimaryCapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration.label
            .font(.inter(18, weight: .bold))
            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(.accent, in: .capsule)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration.label
            .font(.inter(18, weight: .bold))
            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background{
                RoundedRectangle(cornerRadius: 8)
                    .fill(.accent)
                    .shadow(radius: 1)
            }
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
    static var primaryCapsule: PrimaryCapsuleButtonStyle { PrimaryCapsuleButtonStyle() }
}
