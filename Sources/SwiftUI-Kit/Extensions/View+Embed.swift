//
//  View+Embed.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

public extension View {
    func embedInNavigationView() -> some View {
        NavigationView { self }
    }
    
    func embedInScrollView(alignment: Alignment = .center) -> some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                self.frame(
                    minHeight: proxy.size.height,
                    maxHeight: .infinity,
                    alignment: alignment
                )
            }
        }
    }
    
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    func embedInNavigationLink<T: View>(link: T?) -> some View {
        IfLetViewPlaceholder(value: link, content: {
            NavigationLink(destination: $0) {
                self
            }
        }) {
            self
        }
    }
    
    @available(iOS 16.0, *)
    @available(macOS 13.0, *)
    func embedInNavigationLink<P: Hashable>(value: P?) -> some View {
        NavigationLink(value: value, label: { self })
    }
    
    func embedInNavigationLink<V: View>(destination: () -> V) -> some View {
        NavigationLink(destination: destination, label: { self })
    }
    
    @available(iOS 16.0, *)
    @available(macOS 13.0, *)
    func embedInNavigationStack() -> some View {
        NavigationStack { self }
    }
    
    @available(iOS 16.0, *)
    @available(macOS 13.0, *)
    func embedInNavigationStack<Data>(with path: Binding<Data>) -> some View where Data : MutableCollection, Data : RandomAccessCollection, Data : RangeReplaceableCollection, Data.Element : Hashable {
        NavigationStack(path: path) { self }
    }
    
    func embedInPlainButton(action: @escaping () -> Void) -> some View {
        Button(action: action, label: { self })
            .buttonStyle(.plain)
    }
}
