//===--- IfLetViewPlaceholder.swift ------------------------------===//
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

/// A view that conditionally displays content based on the presence of an optional value, with a placeholder for the `nil` case.
public struct IfLetViewPlaceholder<Value, Content: View, Placeholder: View>: View {
    public let value: Value?
    public var content: (Value) -> Content
    public var placeholder: () -> Placeholder
    
    /// Creates an `IfLetViewPlaceholder`.
    /// - Parameters:
    ///   - value: An optional value that determines whether to display the content.
    ///   - content: A closure that takes the unwrapped value and returns the content to be displayed.
    ///   - placeholder: A closure that returns the placeholder view to be displayed when the value is `nil`.
    public init(value: Value?, @ViewBuilder content: @escaping (Value) -> Content, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.value = value
        self.content = content
        self.placeholder = placeholder
    }
    
    public var body: some View {
        Group {
            if value != nil {
                content(value!)
            } else {
                placeholder()
            }
        }
    }
}

struct IfLetViewPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        IfLetViewPlaceholder(value: true, content: { _ in
            Text("value")
        }) {
            Text("placeholder")
        }
    }
}
