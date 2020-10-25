//
//  Binding.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

public extension Binding where Value == Bool {
    
    func toggleAction() -> () -> Void {
        return {
            self.wrappedValue.toggle()
        }
    }
    
    func animationToggleAction(_ animation: Animation = .easeInOut) -> () -> Void {
        return {
            withAnimation(animation) {
                self.wrappedValue.toggle()
            }
        }
    }
}

public extension Binding where Value == PresentationMode {
    func dismissAction() -> () -> Void {
        return {
            self.wrappedValue.dismiss()
        }
    }
}

public extension Binding {
    init(value: Value, action: @escaping () -> Void) {
        self.init(get: { value }, set: { _ in action()} )
    }
    
    init(get: @escaping () -> Value, action: @escaping () -> Void) {
        self.init(get: get, set: { _ in action() })
    }
    
    init(get: @escaping () -> Value, action: @escaping (Value) -> Void) {
        self.init(get: get, set: { action($0) })
    }
    
    init(readOnly get: @escaping () -> Value) {
        self.init(get: get, set: { _ in })
    }
    
    init(value: Value) {
        self.init(get: { value }, set: { _ in })
    }
}
