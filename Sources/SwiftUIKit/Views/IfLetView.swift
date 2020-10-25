//
//  IfLetView.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

public struct IfLetView<Value, Content: View>: View {
    public let value: Value?
    public var content: (Value) -> Content
    
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

