//
//  Binding+Observing.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

public extension Binding {
    /// Wrapper to listen to didSet of Binding
     func didSet(_ didSet: @escaping (_ newValue: Value, _ oldValue: Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                let oldValue = self.wrappedValue
                self.wrappedValue = newValue
                didSet(newValue, oldValue)
            }
        )
    }
    
    /// Wrapper to listen to willSet of Binding
    func willSet(_ willSet: @escaping (_ newValue: inout Value, _ oldValue: Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                var mutableNewValue = newValue
                willSet(&mutableNewValue, self.wrappedValue)
                self.wrappedValue = mutableNewValue
            }
        )
    }
}
