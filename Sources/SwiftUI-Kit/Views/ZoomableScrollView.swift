//
//  ZoomableScrollView.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 07.07.2025.
//

import SwiftUI

/// A SwiftUI-compatible scroll view that supports pinch-to-zoom gestures on its content.
///
/// This wrapper around `UIScrollView` enables zooming behavior for any SwiftUI view.
/// It uses a `UIHostingController` to embed SwiftUI content in a UIKit-based scroll view.
///
/// - Note: Zooming supports scale from `1x` to `5x`.
public struct ZoomableScrollView<Content: View>: UIViewRepresentable {
    private var content: Content

    /// Initializes a `ZoomableScrollView` with the given content.
    ///
    /// - Parameter content: A SwiftUI view builder closure containing the zoomable content.
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public func makeUIView(context: Context) -> some UIView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.maximumZoomScale = 5
        scrollView.minimumZoomScale = 1
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        scrollView.backgroundColor = .clear

        let hostedView = context.coordinator.hostingController.view!
        hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostedView.frame = scrollView.frame
        scrollView.addSubview(hostedView)

        return scrollView
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(hostingController: UIHostingController(rootView: self.content))
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.hostingController.rootView = self.content
    }

    /// A coordinator that manages the scroll view delegate and the embedded SwiftUI content.
    public final class Coordinator: NSObject, UIScrollViewDelegate {
        /// The `UIHostingController` used to embed SwiftUI content inside the scroll view.
        var hostingController: UIHostingController<Content>

        init(hostingController: UIHostingController<Content>) {
            hostingController.view.backgroundColor = .clear
            self.hostingController = hostingController
        }
        /// Returns the view that should respond to zooming.
        public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            hostingController.view
        }
    }
}
