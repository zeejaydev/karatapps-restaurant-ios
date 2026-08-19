//
//  Menu.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/17/26.
//

import SwiftUI

struct Menu: View {
    var body: some View {
        ScrollView {
            LazyVStack{
                ForEach(0..<100) {
                    Text("\($0)")
                }
            }
        }
        .scrollableHeader(dismissDistance: 60) {
            Header()
        }
        .scrollIndicators(.hidden)
        .safeAreaPadding([.horizontal, .bottom])
    }
    
    @ViewBuilder
    func Header() -> some View {
        HStack(alignment: .center) {
            Image(.locationPin)
            Button {
                print("loc")
            } label: {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Ordering At")
                        .font(.caption)
                    HStack(spacing: 10) {
                        Text("South Jordan")
                        Image(systemName: "chevron.down")
                    }
                }
            }
            .buttonStyle(.plain)

            Spacer()
            if #available(iOS 26.0, *) {
                Button {
                    print("test")
                } label: {
                    Image(systemName: "cart")
                }
                .buttonStyle(.glass)
            } else {
                Button {
                    print("test")
                } label: {
                    Image(systemName: "cart")
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 15)
        .background(Color.BG)
    }
}

#Preview {
    @Previewable @State var activeTab: AppTabs = .menu
    TabView(selection: $activeTab) {
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
}
