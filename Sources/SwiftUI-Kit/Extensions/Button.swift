//===--- Button.swift --------------------------------------------===//
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

public extension Button where Label == Image {
    
    /// Initializes a button with an image and an action.
    /// - Parameters:
    ///   - image: The image to be used as the button's label.
    ///   - action: The closure to execute when the button is pressed.
    init(image: Label, action: @escaping () -> Void) {
        self.init(action: action) {
            image.original
        }
    }
}
