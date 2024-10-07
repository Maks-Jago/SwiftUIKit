//===--- Binding+Observing.swift ---------------------------------===//
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

public extension Binding {
    
    /// Wraps the binding to listen for changes using a `didSet`-like mechanism.
    /// - Parameter didSet: A closure that is called whenever the binding's value changes.
    ///   - newValue: The new value that was set.
    ///   - oldValue: The previous value before the change.
    /// - Returns: A new binding that triggers the `didSet` closure on value change.
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
    
    /// Wraps the binding to listen for changes using a `willSet`-like mechanism.
    /// - Parameter willSet: A closure that is called just before the binding's value changes.
    ///   - newValue: An `inout` parameter representing the new value to be set.
    ///   - oldValue: The current value before the change.
    /// - Returns: A new binding that triggers the `willSet` closure just before the value changes.
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
