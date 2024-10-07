//===--- ShareSheet.swift ----------------------------------------===//
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
import SwiftUI

/// A SwiftUI wrapper for `UIActivityViewController` to share items using the system share sheet.
public struct ShareSheet: UIViewControllerRepresentable {
    public typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    public var activityItems: [Any]
    public var applicationActivities: [UIActivity]? = nil
    public var excludedActivityTypes: [UIActivity.ActivityType]? = nil
    public var callback: Callback? = nil
    
    /// Creates a `ShareSheet`.
    /// - Parameters:
    ///   - activityItems: The items to share.
    ///   - applicationActivities: An array of custom activities to display in the share sheet. Default is `nil`.
    ///   - excludedActivityTypes: An array of activity types to exclude from the share sheet. Default is `nil`.
    ///   - callback: A closure to handle the completion of the share action. Default is `nil`.
    public init(
        activityItems: [Any],
        applicationActivities: [UIActivity]? = nil,
        excludedActivityTypes: [UIActivity.ActivityType]? = nil,
        callback: ShareSheet.Callback? = nil
    ) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
        self.excludedActivityTypes = excludedActivityTypes
        self.callback = callback
    }
    
    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#endif
