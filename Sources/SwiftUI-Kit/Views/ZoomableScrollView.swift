//
//  ZoomableScrollView.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 07.07.2025.
//

import SwiftUI

/// A SwiftUI-compatible scroll view that supports pinch-to-zoom gestures on its content.
///
/// This `ZoomableScrollView` wraps any SwiftUI content in a `UIScrollView`, enabling pinch-to-zoom functionality
/// via `UIScrollViewDelegate` and `UIHostingController`.
public struct ZoomableScrollView<Content: View>: UIViewRepresentable {
    private let maxZoomScale: CGFloat
    private let minZoomScale: CGFloat
    private let showsVerticalScrollIndicator: Bool
    private let showsHorizontalScrollIndicator: Bool
    private let bouncesZoom: Bool
    private let automaticallyAdjustsScrollIndicatorInsets: Bool
    private let backgroundColor: UIColor
    private var content: Content

    /// Initializes a `ZoomableScrollView` with the provided parameters and content.
    ///
    /// - Parameters:
    ///   - maxZoomScale: The maximum allowed zoom scale. Default is `5`.
    ///   - minZoomScale: The minimum allowed zoom scale. Default is `1`.
    ///   - showsVerticalScrollIndicator: Whether to show vertical scroll indicators. Default is `false`.
    ///   - showsHorizontalScrollIndicator: Whether to show horizontal scroll indicators. Default is `false`.
    ///   - bouncesZoom: Whether the scroll view bounces during zooming. Default is `true`.
    ///   - automaticallyAdjustsScrollIndicatorInsets: Whether scroll indicator insets adjust automatically. Default is `false`.
    ///   - backgroundColor: The scroll view background color. Default is `.clear`.
    ///   - content: A SwiftUI `ViewBuilder` closure that returns the content to display and zoom.
    public init(
        maxZoomScale: CGFloat = 5,
        minZoomScale: CGFloat = 1,
        showsVerticalScrollIndicator: Bool = false,
        showsHorizontalScrollIndicator: Bool = false,
        bouncesZoom: Bool = true,
        automaticallyAdjustsScrollIndicatorInsets: Bool = false,
        backgroundColor: UIColor = .clear,
        @ViewBuilder content: () -> Content
    ) {
        self.maxZoomScale = maxZoomScale
        self.minZoomScale = minZoomScale
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        self.bouncesZoom = bouncesZoom
        self.automaticallyAdjustsScrollIndicatorInsets = automaticallyAdjustsScrollIndicatorInsets
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    /// Creates and configures the underlying `UIScrollView` and adds the SwiftUI content via `UIHostingController`.
    public func makeUIView(context: Context) -> some UIView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.maximumZoomScale = maxZoomScale
        scrollView.minimumZoomScale = minZoomScale
        scrollView.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        scrollView.bouncesZoom = bouncesZoom
        scrollView.automaticallyAdjustsScrollIndicatorInsets = automaticallyAdjustsScrollIndicatorInsets
        scrollView.backgroundColor = backgroundColor

        let hostedView = context.coordinator.hostingController.view!
        hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostedView.frame = scrollView.frame
        scrollView.addSubview(hostedView)

        return scrollView
    }

    /// Updates the SwiftUI content hosted in the scroll view when the state changes.
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.hostingController.rootView = self.content
    }

    /// Creates the coordinator that handles zooming and manages the hosting controller.
    public func makeCoordinator() -> Coordinator {
        Coordinator(hostingController: UIHostingController(rootView: self.content))
    }

    /// A coordinator that serves as the scroll view delegate and hosts the SwiftUI content.
    public final class Coordinator: NSObject, UIScrollViewDelegate {
        /// The hosting controller used to embed SwiftUI content in the scroll view.
        var hostingController: UIHostingController<Content>

        init(hostingController: UIHostingController<Content>) {
            hostingController.view.backgroundColor = .clear
            self.hostingController = hostingController
        }

        /// Specifies the view to be zoomed inside the scroll view.
        public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            hostingController.view
        }
    }
}
