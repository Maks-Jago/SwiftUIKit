//===--- NavigationLink.swift ------------------------------------===//
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

public extension NavigationLink where Label == EmptyView {
    
    /// Creates a `NavigationLink` with an empty label.
    /// - Parameters:
    ///   - isActive: A binding to a Boolean value that determines whether the link is active.
    ///   - destination: A view builder that creates the destination view for the navigation link.
    init(isActive: Binding<Bool>, @ViewBuilder destination: @escaping () -> Destination) {
        self.init(isActive: isActive, destination: destination) { EmptyView() }
    }
}
