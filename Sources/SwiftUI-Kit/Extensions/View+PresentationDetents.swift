//
//  View+PresentationDetents.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 08.07.2025.
//

import SwiftUI

public extension View {

    /// Presents a bottom sheet when the given item is non-nil, with support for detent selection.
    /// - Parameters:
    ///   - presentationDetents: A set of allowed detents (e.g., `.medium`, `.large`).
    ///   - selectedDetent: A binding to the currently selected detent.
    ///   - item: A binding to an optional `Identifiable` item; if not `nil`, the sheet is presented.
    ///   - dragIndicatorVisibility: Controls the visibility of the drag indicator. Defaults to `.visible`.
    ///   - interactiveDismissDisabled: If `true`, disables interactive dismissal. Defaults to `false`.
    ///   - content: A view builder that creates the content of the sheet based on the provided item.
    /// - Returns: A view with conditional bottom sheet presentation based on iOS version.
    @available(iOS 16.0, *)
    @ViewBuilder
    func bottomSheet<Content: View, Item: Identifiable> (
        presentationDetents: Set<PresentationDetent>,
        selectedDetent: Binding<PresentationDetent>,
        item: Binding<Item?>,
        dragIndicatorVisibility: Visibility = .visible,
        interactiveDismissDisabled: Bool = false,
        @ViewBuilder content: @escaping (_ item: Item) -> Content
    ) -> some View {
        if #available(iOS 16.4, *) {
            self
                .sheet(item: item) { item in
                    content(item)
                        .presentationDetents(presentationDetents, selection: selectedDetent)
                        .presentationDragIndicator(dragIndicatorVisibility)
                        .interactiveDismissDisabled(interactiveDismissDisabled)
                        .presentationBackgroundInteraction(.enabled)
                }
        } else {
            self
                .sheet(item: item) { item in
                    content(item)
                        .presentationDetents(presentationDetents, selection: selectedDetent)
                        .presentationDragIndicator(dragIndicatorVisibility)
                        .interactiveDismissDisabled(interactiveDismissDisabled)
                        .onAppear {
                            guard let window = UIApplication.shared.activeWindow else { return }
                            
                            if let controller = window.rootViewController?.presentedViewController,
                               let sheet = controller.presentationController as? UISheetPresentationController {
                                sheet.largestUndimmedDetentIdentifier = .large
                            }
                        }
                }
        }
    }

    /// Presents a bottom sheet when `isPresented` is `true`, with support for detent selection.
    /// - Parameters:
    ///   - presentationDetents: A set of allowed detents (e.g., `.medium`, `.large`).
    ///   - selectedDetent: A binding to the currently selected detent.
    ///   - isPresented: A binding that controls the presentation state of the sheet.
    ///   - dragIndicatorVisibility: Controls the visibility of the drag indicator. Defaults to `.visible`.
    ///   - interactiveDismissDisabled: If `true`, disables interactive dismissal. Defaults to `true`.
    ///   - content: A view builder that creates the content of the sheet.
    /// - Returns: A view with conditional bottom sheet presentation based on iOS version.
    @available(iOS 16.0, *)
    @ViewBuilder
    func bottomSheet<Content: View> (
        presentationDetents: Set<PresentationDetent>,
        selectedDetent: Binding<PresentationDetent>,
        isPresented: Binding<Bool>,
        dragIndicatorVisibility: Visibility = .visible,
        interactiveDismissDisabled: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        if #available(iOS 16.4, *) {
            self
                .sheet(isPresented: isPresented) {
                    content()
                        .presentationDetents(presentationDetents, selection: selectedDetent)
                        .presentationDragIndicator(dragIndicatorVisibility)
                        .interactiveDismissDisabled(interactiveDismissDisabled)
                        .presentationBackgroundInteraction(.enabled)
                }
        } else {
            self
                .sheet(isPresented: isPresented) {
                    content()
                        .presentationDetents(presentationDetents, selection: selectedDetent)
                        .presentationDragIndicator(dragIndicatorVisibility)
                        .interactiveDismissDisabled(interactiveDismissDisabled)
                        .onAppear {
                            guard let window = UIApplication.shared.activeWindow else { return }
                            
                            if let controller = window.rootViewController?.presentedViewController,
                               let sheet = controller.presentationController as? UISheetPresentationController {
                                sheet.largestUndimmedDetentIdentifier = .large
                            }
                        }
                }
        }
    }

    /// Presents a bottom sheet when `isPresented` is `true`, without support for detent selection binding.
    /// - Parameters:
    ///   - presentationDetents: A set of allowed detents (e.g., `.medium`, `.large`).
    ///   - isPresented: A binding that controls the presentation state of the sheet.
    ///   - dragIndicatorVisibility: Controls the visibility of the drag indicator. Defaults to `.visible`.
    ///   - interactiveDismissDisabled: If `true`, disables interactive dismissal. Defaults to `true`.
    ///   - content: A view builder that creates the content of the sheet.
    /// - Returns: A view with conditional bottom sheet presentation based on iOS version.
    @available(iOS 16.0, *)
    @ViewBuilder
    func bottomSheet<Content: View> (
        presentationDetents: Set<PresentationDetent>,
        isPresented: Binding<Bool>,
        dragIndicatorVisibility: Visibility = .visible,
        interactiveDismissDisabled: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        if #available(iOS 16.4, *) {
            self
                .sheet(isPresented: isPresented) {
                    content()
                        .presentationDetents(presentationDetents)
                        .presentationDragIndicator(dragIndicatorVisibility)
                        .interactiveDismissDisabled(interactiveDismissDisabled)
                        .presentationBackgroundInteraction(.enabled)
                }
        } else {
            self
                .sheet(isPresented: isPresented) {
                    content()
                        .presentationDetents(presentationDetents)
                        .presentationDragIndicator(dragIndicatorVisibility)
                        .interactiveDismissDisabled(interactiveDismissDisabled)
                        .onAppear {
                            guard let window = UIApplication.shared.activeWindow else { return }
                            
                            if let controller = window.rootViewController?.presentedViewController,
                               let sheet = controller.presentationController as? UISheetPresentationController {
                                sheet.largestUndimmedDetentIdentifier = .large
                            }
                        }
                }
        }
    }
}
