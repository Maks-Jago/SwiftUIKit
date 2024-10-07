//===--- UIEdgeInsets+Extensions.swift ---------------------------===//
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

#if os(iOS)
public extension UIEdgeInsets {
    
    /// Converts `UIEdgeInsets` to SwiftUI's `EdgeInsets`.
    var edgeInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
#endif
