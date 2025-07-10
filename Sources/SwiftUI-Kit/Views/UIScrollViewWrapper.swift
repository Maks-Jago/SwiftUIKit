//
//  UIScrollViewWrapper.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 09.07.2025.
//

import SwiftUI

/// A SwiftUI wrapper around a `UIScrollView` to enable **vertical paging** with SwiftUI content.
/// The `VerticalPagingScrollView` allows embedding SwiftUI views inside a UIKit-based scroll view,
/// providing a vertical paging experience similar to `TabView` but vertically.
///
/// Example usage:
/// ```swift
/// VerticalPagingScrollView(page: $currentIndex) {
///     VStack {
///         Text("Page 1")
///         Text("Page 2")
///         Text("Page 3")
///     }
/// }
/// ```
///
/// - Parameters:
///   - page: A binding to the currently visible vertical page.
///   - content: A closure that defines the paged content.
public struct VerticalPagingScrollView<Content: View>: UIViewControllerRepresentable {
    @Binding var page: Int
    var content: () -> Content

    public init(page: Binding<Int>, @ViewBuilder content: @escaping () -> Content) {
        self._page = page
        self.content = content
    }

    public func makeUIViewController(context: Context) -> VerticalPagingViewController<Content> {
        let vc = VerticalPagingViewController(rootView: self.content())
        vc.scrollView.delegate = context.coordinator
        return vc
    }

    public func updateUIViewController(_ viewController: VerticalPagingViewController<Content>, context: Context) {
        viewController.rootView = self.content()
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(page: self._page)
    }

    public class Coordinator: NSObject, UIScrollViewDelegate {
        let page: Binding<Int>

        public init(page: Binding<Int>) {
            self.page = page
        }

        public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let pageHeight = scrollView.frame.size.height
            let page = Int(floor((scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1)
            self.page.wrappedValue = page
        }
    }
}

/// A `UIViewController` subclass that manages a vertical `UIScrollView` and hosts SwiftUI content inside it.
public final class VerticalPagingViewController<Content: View>: UIViewController {
    // A vertical paging scroll view
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.isPagingEnabled = true
        v.showsVerticalScrollIndicator = false
        v.contentInsetAdjustmentBehavior = .never
        v.isDirectionalLockEnabled = true
        v.backgroundColor = .black
        return v
    }()

    // UIHostingController for rendering SwiftUI content inside UIScrollView
    private var hostingController: UIHostingController<Content>!

    var rootView: Content {
        get { hostingController.rootView }
        set { hostingController.rootView = newValue }
    }

    convenience init(rootView: Content) {
        self.init()
        self.hostingController = .init(rootView: rootView)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView)
        self.pinEdges(of: self.scrollView, to: self.view)
        self.hostingController.willMove(toParent: self)
        self.hostingController._disableSafeArea = true
        self.scrollView.addSubview(self.hostingController.view)
        self.pinEdges(of: self.hostingController.view, to: self.scrollView)
        self.hostingController.didMove(toParent: self)
    }

    // Pins one view's edges to another's with Auto Layout constraints.
    func pinEdges(of viewA: UIView, to viewB: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        viewB.addConstraints([
            viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
            viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor),
            viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
            viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor),
            viewA.widthAnchor.constraint(equalTo: viewB.widthAnchor),
        ])
    }
}
