//===--- View+OnDeepLink.swift -----------------------------------===//
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

public extension View {

    /// Calls an action for custom-scheme URLs, universal links, and universal links from scanned QR codes.
    ///
    /// This modifier combines `onOpenURL(perform:)` and `onContinueUserActivity(_:perform:)` for
    /// `NSUserActivityTypeBrowsingWeb`, so one closure receives all of these links.
    ///
    /// Both are needed because the system delivers links in different ways. Custom-scheme URLs (`myapp://...`) and
    /// universal links opened by URL arrive through `onOpenURL(perform:)`. A universal link opened by scanning a QR code
    /// arrives as a browsing-web user activity, which `onOpenURL(perform:)` alone does not receive.
    ///
    /// Each link reaches only one of the two handlers, so `action` is called once per link.
    ///
    /// ```swift
    /// ContentView()
    ///     .onDeepLink { url in
    ///         handle(url)
    ///     }
    /// ```
    ///
    /// - Parameter action: The closure to call with the URL of each incoming link.
    /// - Returns: A view that calls `action` when the app receives a link.
    func onDeepLink(perform action: @escaping (URL) -> Void) -> some View {
        onOpenURL(perform: action)
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                if let url = activity.webpageURL {
                    action(url)
                }
            }
    }
}
