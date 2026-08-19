//
//  ScrollableHeader.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/15/26.
//

import SwiftUI

extension ScrollView {
    @ViewBuilder
    func scrollableHeader<Header: View>(
        dismissDistance: CGFloat,
        @ViewBuilder header: @escaping () -> Header
    ) -> some View {
        self
            .modifier(
                ScrollableHeaderModifier(
                    dismissDistance: dismissDistance,
                    header: header
                )
            )
    }
}

fileprivate struct ScrollableHeaderModifier<Header: View>: ViewModifier {
    var dismissDistance: CGFloat
    @ViewBuilder var header: Header
    /// View Props
    @State private var scrollOffset: CGFloat = 0
    @State private var scrollPhase: ScrollPhase = .idle
    @State private var scrollDirection: ScrollDirection? = nil
    @State private var shiftScrollOffset: CGFloat = 0
    @State private var headerProgress: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .top, spacing: 0) {
                header
                    .compositingGroup()
                    .offset(y: headerProgress * -dismissDistance)
                    .opacity(1 - headerProgress)
            }
            .onScrollGeometryChange(for: CGFloat.self) {
                let maxHeight = $0.contentSize.height - $0.containerSize.height
                let offset = $0.contentOffset.y + $0.contentInsets.top
                return min(offset, maxHeight)
            } action: { oldValue, newValue in
                scrollOffset = newValue
                
                scrollDirection = scrollPhase == .interacting ? (newValue > oldValue ? .up : .down) : nil
                
                if scrollDirection != nil {
                    let offset = newValue.rounded() - shiftScrollOffset
                    let progress = max(min(offset / dismissDistance, 1), 0)
                    headerProgress = progress
                }
            }
            .onScrollPhaseChange { oldPhase, newPhase in
                scrollPhase = newPhase
                
                if newPhase != .interacting {
                    scrollDirection = nil
                    withAnimation(animation) {
                        if headerProgress > 0.5  && scrollOffset > dismissDistance {
                            headerProgress = 1
                        } else {
                            headerProgress = 0
                        }
                    }
                    
                    shiftScrollOffset = max(scrollOffset - (headerProgress * dismissDistance), 0)
                }
            }
            .onChange(of: scrollDirection) { oldValue, newValue in
                guard newValue != nil else { return }
                shiftScrollOffset = max(scrollOffset - (headerProgress * dismissDistance), 0)
            }
    }
    
    ///Current Scroll Direction
    private enum ScrollDirection {
        case up
        case down
    }
    
    var animation : Animation {
        .interpolatingSpring(duration: 0.3, bounce: 0, initialVelocity: 0)
    }
}

#Preview {
    EmptyView()
}
