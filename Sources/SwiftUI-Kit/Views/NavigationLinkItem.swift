//
//  NavigationLinkItem.swift
//  
//
//  Created by Max Kuznetsov on 08.12.2020.
//

import SwiftUI

public struct NavigationLinkItem<I: Identifiable, D: View, L: View>: View {
    public var item: Binding<I?>
    public var destination: (I) -> D
    public var label: () -> L
    
    init(item: Binding<I?>, @ViewBuilder destination: @escaping (I) -> D, @ViewBuilder label: @escaping () -> L) {
        self.item = item
        self.destination = destination
        self.label = label
    }
    
    private var isActive: Binding<Bool> {
        Binding(
            get: { item.wrappedValue != nil },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
    }
    
    public var body: some View {
        NavigationLink(
            destination: destinationView(),
            isActive: isActive,
            label: label
        )
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        if let value = item.wrappedValue {
            destination(value)
        } else {
            EmptyView()
        }
    }
}

public extension NavigationLinkItem where L == EmptyView {
    init(item: Binding<I?>, @ViewBuilder destination: @escaping (I) -> D) {
        self.init(item: item, destination: destination, label: { EmptyView() })
    }
}
