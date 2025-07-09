//
//  UIScrollViewWrapper.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 09.07.2025.
//

import SwiftUI

/// A SwiftUI wrapper around a `UIScrollView` to enable vertical paging with SwiftUI content.
/// The `UIScrollViewWrapper` allows embedding SwiftUI views inside a `UIScrollView`, providing a UIKit-based scrolling experience with
/// support for paging.
///
/// Example usage:
/// ```swift
/// UIScrollViewWrapper(page: $currentIndex) {
///     VStack {
///         Text("Page 1")
///         Text("Page 2")
///         Text("Page 3")
///     }
/// }
/// ```
///
/// - Parameters:
///   - page: A binding to the currently visible page, which gets updated as the user scrolls.
///   - content: A closure that defines the content of the pages in the scroll view.
struct UIScrollViewWrapper<Content: View>: UIViewControllerRepresentable {
    @Binding var page: Int
    var content: () -> Content

    /// Initializes the `UIScrollViewWrapper`.
    /// - Parameters:
    ///   - page: A binding to the currently visible page index.
    ///   - content: A closure that provides the content inside the scroll view.
    init(page: Binding<Int>, @ViewBuilder content: @escaping () -> Content) {
        self._page = page
        self.content = content
    }

    /// Creates the `UIScrollViewViewController` that will host the SwiftUI content in the scroll view.
    func makeUIViewController(context: Context) -> UIScrollViewViewController<Content> {
        let vc = UIScrollViewViewController(rootView: self.content())
        vc.scrollView.delegate = context.coordinator // Set the scroll delegate to the coordinator for handling scrolling events
        return vc
    }

    /// Updates the content inside the `UIScrollViewViewController` when the SwiftUI view is updated.
    func updateUIViewController(_ viewController: UIScrollViewViewController<Content>, context: Context) {
        viewController.rootView = self.content() // Update the hosted content when the SwiftUI view changes
    }

    /// Creates the coordinator responsible for handling scroll events.
    public func makeCoordinator() -> Coordinator {
        Coordinator(page: self._page)
    }

    /// The coordinator class handles scrolling events and updates the page index.
    public class Coordinator: NSObject, UIScrollViewDelegate {
        let page: Binding<Int>

        init(page: Binding<Int>) {
            self.page = page
        }

        /// Updates the `page` binding when scrolling ends, calculating the current page based on the scroll position.
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let pageHeight = scrollView.frame.size.height
            let page = Int(floor((scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1) // Calculate the page index
            self.page.wrappedValue = page // Update the binding with the current page
        }
    }
}

/// A `UIViewController` subclass that manages a `UIScrollView` and hosts SwiftUI content inside it.
final class UIScrollViewViewController<Content: View>: UIViewController {
    // A lazily initialized UIScrollView with paging enabled
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.isPagingEnabled = true // Enables paging behavior
        v.showsVerticalScrollIndicator = false // Hides the vertical scroll indicator
        v.contentInsetAdjustmentBehavior = .never // Avoids adjusting the content for safe area insets
        v.isDirectionalLockEnabled = true // Locks scrolling direction to vertical
        v.backgroundColor = .black // Sets the background color to black
        return v
    }()

    // A UIHostingController that will host the SwiftUI content
    private var hostingController: UIHostingController<Content>!

    // The SwiftUI root view that will be hosted inside the scroll view
    var rootView: Content {
        get {
            hostingController.rootView
        }
        set {
            hostingController.rootView = newValue
        }
    }

    // Initializer for creating the controller with the SwiftUI root view
    convenience init(rootView: Content) {
        self.init()
        self.hostingController = .init(rootView: rootView)
    }

    // Sets up the scroll view and the hosting controller when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView) // Add the scroll view to the main view
        self.pinEdges(of: self.scrollView, to: self.view) // Pin the scroll view edges to the parent view
        self.hostingController.willMove(toParent: self) // Prepare the hosting controller for layout
        self.hostingController._disableSafeArea = true // Disable safe area constraints for the hosted content
        self.scrollView.addSubview(self.hostingController.view) // Add the SwiftUI content to the scroll view
        self.pinEdges(of: self.hostingController.view, to: self.scrollView) // Pin the hosted view inside the scroll view
        self.hostingController.didMove(toParent: self) // Notify the hosting controller that it has moved to the parent
    }

    // Helper method to pin the edges of one view to another, setting up constraints
    func pinEdges(of viewA: UIView, to viewB: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        viewB.addConstraints([
            viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
            viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor),
            viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
            viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor),
            viewA.widthAnchor.constraint(equalTo: viewB.widthAnchor), // Ensures the hosted view matches the width of the parent
        ])
    }
}
