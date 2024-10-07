//===--- Binding.swift -------------------------------------------===//
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

public extension Binding where Value == Bool {
    
    /// Returns a closure that toggles the binding's boolean value.
    /// - Returns: A closure that toggles the `Bool` value.
    func toggleAction() -> () -> Void {
        return {
            self.wrappedValue.toggle()
        }
    }
    
    /// Returns a closure that toggles the binding's boolean value with animation.
    /// - Parameter animation: The animation to apply when toggling the value. Default is `.easeInOut`.
    /// - Returns: A closure that toggles the `Bool` value with the specified animation.
    func animationToggleAction(_ animation: Animation = .easeInOut) -> () -> Void {
        return {
            withAnimation(animation) {
                self.wrappedValue.toggle()
            }
        }
    }
}

public extension Binding where Value == PresentationMode {
    
    /// Returns a closure that dismisses the presentation mode.
    /// - Returns: A closure that dismisses the current presentation mode.
    func dismissAction() -> () -> Void {
        return {
            self.wrappedValue.dismiss()
        }
    }
}

public extension Binding {
    
    /// Creates a binding with a custom getter and an action that triggers on setting a new value.
    /// - Parameters:
    ///   - get: A closure that returns the current value of the binding.
    ///   - action: A closure that is executed when the binding's value is set.
    init(get: @escaping () -> Value, action: @escaping () -> Void) {
        self.init(get: get, set: { _ in action() })
    }
    
    /// Creates a binding with a custom getter and setter.
    /// - Parameters:
    ///   - get: A closure that returns the current value of the binding.
    ///   - action: A closure that is executed when the binding's value is set, passing the new value.
    init(get: @escaping () -> Value, action: @escaping (Value) -> Void) {
        self.init(get: get, set: { action($0) })
    }
    
    /// Creates a read-only binding with a custom getter.
    /// - Parameter get: A closure that returns the current value of the binding.
    init(readOnly get: @escaping () -> Value) {
        self.init(get: get, set: { _ in })
    }
}

public extension Binding {
    
    /// Creates a `Binding<Bool>` that indicates whether the optional value is present.
    /// - Returns: A `Binding<Bool>` that is `true` if the optional value is not `nil`, `false` otherwise.
    func isPresented<T>() -> Binding<Bool> where Value == Optional<T> {
        Binding<Bool>(
            get: {
                switch self.wrappedValue {
                case .some: return true
                case .none: return false
                }
            },
            set: {
                if !$0 {
                    self.wrappedValue = nil
                }
            }
        )
    }
}
