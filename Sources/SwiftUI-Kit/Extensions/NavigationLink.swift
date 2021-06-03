//
//  NavigationLink.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 08.12.2020.
//

import SwiftUI

public extension NavigationLink where Label == EmptyView {
    init(destination: Destination, isActive: Binding<Bool>) {
        self.init(destination: destination, isActive: isActive) { EmptyView() }
    }
    
    init(isActive: Binding<Bool>, @ViewBuilder destination: @escaping () -> Destination) {
        self.init(destination: destination(), isActive: isActive) { EmptyView() }
    }
}

public extension View {
    func navigation<I: Identifiable, D: View>(item: Binding<I?>, @ViewBuilder destination: @escaping (I) -> D) -> some View {
        background(NavigationLinkItem(item: item, destination: destination))
    }
}
