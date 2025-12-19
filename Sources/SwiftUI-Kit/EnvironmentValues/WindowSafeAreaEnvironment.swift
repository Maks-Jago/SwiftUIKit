//===--- SafeAreaInsets.swift ------------------------------------===//
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

#if os(iOS)
/// A private environment key to provide the window's safe area insets.
private struct WindowSafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.activeWindow?.safeAreaInsets ?? .zero).edgeInsets
    }
}

public extension EnvironmentValues {
    /// An environment value to access the window's safe area insets.
    @available(iOS, deprecated: 26.2, message: "Use provideSafeAreaInsets in compination with environment value contentSafeAreaInsets instead")
    var windowSafeAreaInsets: EdgeInsets {
        self[WindowSafeAreaInsetsKey.self]
    }
}
#endif
