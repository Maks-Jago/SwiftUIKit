//===--- Image.swift ---------------------------------------------===//
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

public extension Image {
    
    /// Returns an image using its original rendering mode.
    var original: Self {
        self.renderingMode(.original)
    }
    
    /// Returns an image using the template rendering mode.
    var template: Self {
        self.renderingMode(.template)
    }
    
    /// Configures the image to fit within its available space while preserving its aspect ratio.
    /// - Returns: A view that contains the image with an aspect ratio of `.fit`.
    func aspectFit() -> some View {
        self.resizable().aspectRatio(contentMode: .fit)
    }
    
    /// Configures the image to fill its available space while preserving its aspect ratio.
    /// - Returns: A view that contains the image with an aspect ratio of `.fill`.
    func aspectFill() -> some View {
        self.resizable().aspectRatio(contentMode: .fill)
    }
}
