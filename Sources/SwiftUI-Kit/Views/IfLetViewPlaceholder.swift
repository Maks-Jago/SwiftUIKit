//
//  IfLetViewPlaceholder.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

public struct IfLetViewPlaceholder<Value, Content: View, Placeholder: View>: View {
    public let value: () -> Value?
    public var content: (Value) -> Content
    public var placeholder: () -> Placeholder
    
    public init(
        value: @escaping () -> Value?,
        @ViewBuilder content: @escaping (Value) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.value = value
        self.content = content
        self.placeholder = placeholder
    }
    
    public var body: some View {
        Group {
            if let value = value() {
                content(value)
            } else {
                placeholder()
            }
        }
    }
}

struct IfLetViewPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        IfLetViewPlaceholder(value: { true }, content: { _ in
            Text("value")
        }) {
            Text("placeholder")
        }
    }
}

