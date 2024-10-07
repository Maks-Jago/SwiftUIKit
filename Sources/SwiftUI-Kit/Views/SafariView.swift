//===--- SafariView.swift ----------------------------------------===//
//
// This source file is part of the SwiftUIKit open source project
//
// Copyright (c) 2024 You are launched
// Licensed under MIT License
//
// See https://opensource.org/licenses/MIT for license information
//
//===----------------------------------------------------------------------===//

#if canImport(UIKit)
import SafariServices
import SwiftUI

/// A SwiftUI wrapper for `SFSafariViewController` to display a webpage using Safari in-app.
public struct SafariView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = SFSafariViewController
    
    public let url: URL
    
    /// Creates a `SafariView`.
    /// - Parameter url: The URL of the webpage to display.
    public init(url: URL) {
        self.url = url
    }
    
    public func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
#endif
