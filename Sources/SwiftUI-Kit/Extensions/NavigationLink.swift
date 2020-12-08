//
//  NavigationLink.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 08.12.2020.
//

import SwiftUI

public extension View {
    func navigation<I: Identifiable, D: View>(item: Binding<I?>, @ViewBuilder destination: @escaping (I) -> D) -> some View {
        background(NavigationLink(item: item, destination: destination))
    }
}

public extension NavigationLink where Label == EmptyView {
    init(destination: Destination, isActive: Binding<Bool>) {
        self.init(destination: destination, isActive: isActive) { EmptyView() }
    }
    
    init(isActive: Binding<Bool>, @ViewBuilder destination: @escaping () -> Destination) {
        self.init(destination: destination(), isActive: isActive) { EmptyView() }
    }
    
    init?<I: Identifiable>(item: Binding<I?>, @ViewBuilder destination: @escaping (I) -> Destination) {
        guard let value = item.wrappedValue else {
            return nil
        }
        
        let isActive: Binding<Bool> = Binding(
            get: { item.wrappedValue != nil },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
        
        self.init(
            destination: destination(value),
            isActive: isActive,
            label: { EmptyView() }
        )
    }
}
