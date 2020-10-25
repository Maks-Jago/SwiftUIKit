//
//  IfLetView.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

struct IfLetView<Value, Content: View>: View {
    let value: Value?
    var content: (Value) -> Content
    
    init(value: Value?, @ViewBuilder content: @escaping (Value) -> Content) {
        self.value = value
        self.content = content
    }
    
    var body: some View {
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

