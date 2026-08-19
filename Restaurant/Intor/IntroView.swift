//
//  SwiftUIView.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/15/26.
//

import SwiftUI

struct IntroView: View {
    @Binding var continueWithoutUser: Bool
    
    var body: some View {
            VStack(alignment: .leading, spacing: 22) {
                Image(.intor)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("My Restaurant")
                        .font(.bricolage(weight: .black))
                        .minimumScaleFactor(0.5)
                    Text("Satusfy Your Cravings")
                        .font(.bricolage(35))
                        .minimumScaleFactor(0.5)
                    Text("Taste-led gourmet recipes and hot diner eats delivered to your door steps.")
                        .foregroundStyle(.secondary)
                        .minimumScaleFactor(0.5)
                }
                VStack {
                    Button {
                        print("test")
                    } label: {
                        Text("Sign In")
                            .font(.inter(18, weight: .bold))
                            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .background(.accent, in: .capsule)
                            .overlay(Capsule().strokeBorder(.accent, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        continueWithoutUser.toggle()
                    } label: {
                        Text("Continue As Guest")
                            .font(.inter(18, weight: .bold))
                            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .background(.accent, in: .capsule)
                            .overlay(Capsule().strokeBorder(.accent, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }
}

#Preview {
    @Previewable @State var continueWithoutUser: Bool = false
    IntroView(continueWithoutUser: $continueWithoutUser)
}
