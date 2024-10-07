//===--- IfLetView.swift -----------------------------------------===//
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

/// A view that conditionally displays content based on the presence of an optional value.
public struct IfLetView<Value, Content: View>: View {
    public let value: Value?
    public var content: (Value) -> Content
    
    /// Creates an `IfLetView`.
    /// - Parameters:
    ///   - value: An optional value that determines whether to display the content.
    ///   - content: A closure that takes the unwrapped value and returns the content to be displayed.
    public init(value: Value?, @ViewBuilder content: @escaping (Value) -> Content) {
        self.value = value
        self.content = content
    }
    
    public var body: some View {
        Group {
            if value != nil {
                content(value!)
            }
        }
    }
}

struct IfLetView_Previews: PreviewProvider {
    static var previews: some View {
        IfLetView(value: true) { _ in
            Text("value")
        }
    }
}
