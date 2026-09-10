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
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Image(.intor)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
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
                Spacer()
                VStack(spacing: 12) {
                    Button("Sign In") {
                        print("test")
                    }
                    .buttonStyle(.primary)
                    
                    Button("Continue As Guest") {
                        continueWithoutUser.toggle()
                    }
                    .buttonStyle(.primary)
                }
            }
            .safeAreaPadding()
        }
    }
}

#Preview {
    @Previewable @State var continueWithoutUser: Bool = false
    IntroView(continueWithoutUser: $continueWithoutUser)
}
