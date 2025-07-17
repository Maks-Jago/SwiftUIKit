//
//  View+Snapshot.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 08.07.2025.
//

import SwiftUI

public extension View {
    /// Renders the SwiftUI view as a `UIImage`.
    /// - Returns: A rendered `UIImage` representing the view, or `nil` if rendering fails.
    @available(iOS 14.0, *)
    func snapshot() -> UIImage? {
        // Wrap the SwiftUI view in a UIHostingController.
        let controller = UIHostingController(
            rootView: self.ignoresSafeArea()
                .fixedSize(horizontal: true, vertical: true) // Ensure the view takes only its intrinsic content size.
        )

        // Access the underlying UIView.
        guard let view = controller.view else { return nil }

        // Calculate the target size from the view’s intrinsic content.
        let targetSize = view.intrinsicContentSize
        if targetSize.width <= 0 || targetSize.height <= 0 { return nil }

        // Set up the view bounds and background.
        view.bounds = CGRect(origin: .zero, size: targetSize)
        view.backgroundColor = .clear

        // Create an image renderer with the view's size.
        let renderer = UIGraphicsImageRenderer(size: targetSize)

        // Render the view hierarchy into the image context.
        return renderer.image { _ in
            view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
