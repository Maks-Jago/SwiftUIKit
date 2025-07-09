//
//  AlwaysPopover.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 08.07.2025.
//

import SwiftUI

public extension View {
    /// Presents a popover that is always anchored to a view, even in cases where SwiftUI's native `.popover` might not behave correctly (e.g., iPhone).
    /// - Parameters:
    ///   - isPresented: A binding that controls whether the popover is visible.
    ///   - content: A view builder that provides the content of the popover.
    /// - Returns: A modified view with the custom popover attached.
    func alwaysPopover<Content>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        self.modifier(AlwaysPopoverModifier(isPresented: isPresented, contentBlock: content))
    }
}


public extension UIView {
    /// Traverses the responder chain to find the closest `UIViewController`.
    /// Useful for presenting UIKit components from within SwiftUI.
    func closestVC() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder?.next
        }
        return nil
    }
}

/// A custom `ViewModifier` that presents a UIKit-based popover using a manually inserted anchor view.
struct AlwaysPopoverModifier<PopoverContent>: ViewModifier where PopoverContent: View {
    let isPresented: Binding<Bool>
    let contentBlock: () -> PopoverContent

    /// Internal store to hold the anchor view used as the popover source.
    /// Using struct to simulate `@StateObject` behavior for iOS 13 compatibility.
    private struct Store {
        var anchorView = UIView()
    }
    @State private var store = Store()

    func body(content: Content) -> some View {
        if isPresented.wrappedValue {
            withAnimation {
                presentPopover()
            }
        }

        // Attach the anchor view invisibly to the SwiftUI view hierarchy.
        return content
            .background(InternalAnchorView(uiView: store.anchorView))
    }

    /// Presents the UIKit popover from the closest UIViewController.
    private func presentPopover() {
        let contentController = ContentViewController(rootView: contentBlock(), isPresented: isPresented)
        contentController.modalPresentationStyle = .popover

        let view = store.anchorView
        guard let popover = contentController.popoverPresentationController else { return }
        popover.sourceView = view
        popover.sourceRect = view.bounds
        popover.delegate = contentController
        
        guard let sourceVC = view.closestVC() else { return }

        // If another VC is already presented, dismiss it before showing the popover.
        if let presentedVC = sourceVC.presentedViewController {
            presentedVC.dismiss(animated: true) {
                sourceVC.present(contentController, animated: true)
            }
        } else {
            sourceVC.present(contentController, animated: true)
        }
    }

    /// A representable wrapper to inject a `UIView` into the SwiftUI view hierarchy as an anchor.
    private struct InternalAnchorView: UIViewRepresentable {
        typealias UIViewType = UIView
        let uiView: UIView

        func makeUIView(context: Self.Context) -> Self.UIViewType {
            uiView
        }

        func updateUIView(_ uiView: Self.UIViewType, context: Self.Context) { }
    }
}

/// A `UIHostingController` subclass that hosts SwiftUI content inside a UIKit popover.
class ContentViewController<V>: UIHostingController<V>, UIPopoverPresentationControllerDelegate where V:View {
    /// A binding to track popover visibility state.
    var isPresented: Binding<Bool>

    /// Initializes the controller with SwiftUI content and presentation state binding.
    init(rootView: V, isPresented: Binding<Bool>) {
        self.isPresented = isPresented
        super.init(rootView: rootView)
    }

    /// Required by `UIHostingController`, but not implemented because interface builder is not used.
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Calculate and set preferred size based on content.
        let size = sizeThatFits(in: UIView.layoutFittingExpandedSize)
        preferredContentSize = size
    }

    /// Prevents adaptive presentation (like full screen on iPhone); always shows as popover.
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }

    /// Called when the popover is dismissed. Updates the binding to reflect the change.
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.isPresented.wrappedValue = false
    }
}
