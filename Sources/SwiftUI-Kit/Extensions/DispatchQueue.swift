//===--- DispatchQueue.swift -------------------------------------===//
//
// This source file is part of the SwiftUI-Kit open source project
//
// Copyright (c) 2024 You are launched
// Licensed under MIT License
//
// See https://opensource.org/licenses/MIT for license information
//
//===----------------------------------------------------------------------===//

import SwiftUI

public extension DispatchQueue {
    
    /// Asynchronously executes a block of code on the dispatch queue with a specified animation.
    /// - Parameters:
    ///   - animation: The animation to apply when executing the block. Default is `.default`.
    ///   - block: A closure that contains the code to be executed asynchronously with animation.
    func asyncWithAnimation(_ animation: Animation = .default, _ block: @escaping () -> Void) {
        self.async {
            withAnimation(animation) {
                block()
            }
        }
    }
}
