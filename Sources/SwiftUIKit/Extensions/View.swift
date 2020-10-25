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
