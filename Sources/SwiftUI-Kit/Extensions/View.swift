//
//  View.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

public extension View {
    func onTapGestureWithAnimation(_ animation: Animation = .easeInOut, perform: @escaping () -> Void) -> some View {
        self.onTapGesture {
            withAnimation(animation, perform)
        }
    }

    func printValue<V>(_ value: V) -> some View {
        print("\(value)")
        return self
    }

    func hideKeyboardByTap() -> some View {
        self.onTapGesture {
            obtainKeyWindow()?.endEditing(true)
        }
    }
}


public extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

public extension View where Self: Equatable {
    func equatable() -> EquatableView<Self> {
        EquatableView(content: self)
    }
}
