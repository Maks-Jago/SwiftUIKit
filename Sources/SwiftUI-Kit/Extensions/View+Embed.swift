//===--- View+Embed.swift ----------------------------------------===//
//
// This source file is part of the SwiftUIKit open source project
//
// Copyright (c) 2024 You are launched
// Licensed under MIT License
//
// See https://opensource.org/licenses/MIT for license information
//
//===----------------------------------------------------------------------===//

import SwiftUI

public extension View {
    
    /// Embeds the view inside a `NavigationView`.
    /// - Returns: A modified view wrapped in a `NavigationView`.
    func embedInNavigationView() -> some View {
        NavigationView { self }
    }
    
    /// Embeds the view inside a `ScrollView` with a specified alignment.
    /// - Parameter alignment: The alignment for the view inside the `ScrollView`. Default is `.center`.
    /// - Returns: A modified view wrapped in a `ScrollView`.
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
    
    /// Converts the view to an `AnyView` to erase its type.
    /// - Returns: An `AnyView` containing the current view.
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    /// Embeds the view inside a `NavigationLink` if a destination view is provided.
    /// - Parameter link: The destination view to navigate to.
    /// - Returns: A modified view wrapped in a `NavigationLink` if the destination is not `nil`.
    func embedInNavigationLink<T: View>(link: T?) -> some View {
        IfLetViewPlaceholder(value: link, content: {
            NavigationLink(destination: $0) {
                self
            }
        }) {
            self
        }
    }
    
    /// Embeds the view inside a `NavigationLink` with a value for navigation.
    /// - Parameter value: The value to use for navigation.
    /// - Returns: A modified view wrapped in a `NavigationLink`.
    @available(iOS 16.0, *)
    @available(macOS 13.0, *)
    func embedInNavigationLink<P: Hashable>(value: P?) -> some View {
        NavigationLink(value: value, label: { self })
    }
    
    /// Embeds the view inside a `NavigationLink` with a specified destination.
    /// - Parameter destination: A closure that creates the destination view.
    /// - Returns: A modified view wrapped in a `NavigationLink`.
    func embedInNavigationLink<V: View>(destination: () -> V) -> some View {
        NavigationLink(destination: destination, label: { self })
    }
    
    /// Embeds the view inside a `NavigationStack`.
    /// - Returns: A modified view wrapped in a `NavigationStack`.
    @available(iOS 16.0, *)
    @available(macOS 13.0, *)
    func embedInNavigationStack() -> some View {
        NavigationStack { self }
    }
    
    /// Embeds the view inside a `NavigationStack` using a binding path.
    /// - Parameter path: A binding to the navigation path.
    /// - Returns: A modified view wrapped in a `NavigationStack` with a bound path.
    @available(iOS 16.0, *)
    @available(macOS 13.0, *)
    func embedInNavigationStack<Data>(with path: Binding<Data>) -> some View where Data: MutableCollection, Data: RandomAccessCollection, Data: RangeReplaceableCollection, Data.Element: Hashable {
        NavigationStack(path: path) { self }
    }
    
    /// Embeds the view inside a plain button with an action.
    /// - Parameter action: The action to perform when the button is tapped.
    /// - Returns: A modified view wrapped in a plain button.
    func embedInPlainButton(action: @escaping () -> Void) -> some View {
        Button(
            action: action,
            label: {
                self.contentShape(Rectangle())
            }
        )
        .buttonStyle(.plain)
    }
}
