//
//  SwiftUIPagerView.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 09.07.2025.
//

import SwiftUI

/// A pager view component that allows users to swipe between pages, either vertically or horizontally.
/// The `SwiftUIPagerView` adapts its behavior based on the iOS version to provide a smooth paging experience.
///
/// Example usage:
/// ```swift
/// struct PageModel: Hashable {
///     let id: Int
///     let title: String
/// }
///
/// @State private var currentPage = PageModel(id: 0, title: "Page 1")
///
/// var body: some View {
///     SwiftUIPagerView(
///         pages: [PageModel(id: 0, title: "Page 1"), PageModel(id: 1, title: "Page 2")],
///         axis: .horizontal, // or .vertical
///         currentItem: $currentPage
///     ) { page in
///         Text(page.title)
///             .frame(maxWidth: .infinity, maxHeight: .infinity)
///             .background(Color.blue)
///             .cornerRadius(12)
///     }
/// }
/// ```
///
/// - Parameters:
///   - pages: An array of `TModel` items representing each page in the pager.
///   - axis: The scroll direction for paging (horizontal or vertical).
///   - currentItem: A binding to the currently selected page item.
///   - isScrollEnabled: A binding that enables or disables scrolling.
///   - builder: A closure that defines the view for each page.
@available(iOS 17.0, *)
public struct SwiftUIPagerView<TModel: Hashable, TView: View>: View {
    private let pages: [TModel]
    private let axis: Axis.Set
    @Binding private var currentItem: TModel
    @Binding private var isScrollEnabled: Bool
    private let builder: (TModel) -> TView

    /// Initializes a `SwiftUIPagerView`.
    /// - Parameters:
    ///   - pages: An array of pages to display.
    ///   - axis: The scroll direction for paging (horizontal or vertical).
    ///   - currentItem: A binding to the currently selected page.
    ///   - isScrollEnabled: A binding that enables or disables scrolling.
    ///   - builder: A closure that returns a view for each page.
    public init(
        pages: [TModel],
        axis: Axis.Set = .horizontal,
        currentItem: Binding<TModel>,
        isScrollEnabled: Binding<Bool> = .constant(true),
        @ViewBuilder builder: @escaping (TModel) -> TView
    ) {
        self.pages = pages
        self.axis = axis
        self._currentItem = currentItem
        self._isScrollEnabled = isScrollEnabled
        self.builder = builder
    }

    public var body: some View {
        GeometryReader { geometry in
            ScrollView(axis, showsIndicators: false) {
                pagesView(geometry: geometry)
                    .scrollTargetLayout() // Optimizes the layout for smooth scrolling
            }
            .scrollDisabled(!isScrollEnabled)
            .ignoresSafeArea() // The scroll view extends to the edges of the screen
            .scrollTargetBehavior(.paging) // Enables paging behavior, so the user scrolls page by page
            // Binding the scroll position to the current item, so when the currentItem changes, the scroll view updates its position
            .scrollPosition(
                id: Binding(
                    get: {
                        currentItem // Get the current item
                    },
                    set: { newValue in
                        // When a new value is selected, update the current item
                        if let newValue {
                            currentItem = newValue
                        }
                    }
                )
            )
            .onPreferenceChange(VisiblePagePreferenceKey.self) { newValue in
                if let newPage = newValue as? TModel, newPage != currentItem {
                    currentItem = newPage
                }
            }
        }
    }

    @ViewBuilder
    private func pagesView(geometry: GeometryProxy) -> some View {
        switch axis {
        case .horizontal:
            LazyHStack(spacing: 0) {
                ForEach(self.pages, id: \.self) { page in
                    // Build each page using the provided builder
                    self.builder(page)
                        .id(page) // Assigns a unique ID to each page for scrolling and layout purposes
                        .background(
                            GeometryReader { geo in
                                Color.white.opacity(0.001)
                                    .preference(
                                        key: VisiblePagePreferenceKey.self,
                                        value: computeVisibility(geometry: geo, page: page, container: geometry).map(AnyHashable.init)
                                    )
                            }
                        )
                        .ignoresSafeArea() // Ensures the content extends to the edges of the screen
                        .frame(minWidth: geometry.size.width) // Set the width of each page
                }
            }
            .frame(height: geometry.size.height) // Set the height of the scrollable area to match the screen width

        default:
            LazyVStack(spacing: 0) {
                ForEach(self.pages, id: \.self) { page in
                    // Build each page using the provided builder
                    self.builder(page)
                        .id(page) // Assigns a unique ID to each page for scrolling and layout purposes
                        .background(
                            GeometryReader { geo in
                                Color.white.opacity(0.001)
                                    .preference(
                                        key: VisiblePagePreferenceKey.self,
                                        value: computeVisibility(geometry: geo, page: page, container: geometry).map(AnyHashable.init)
                                    )
                            }
                        )
                        .ignoresSafeArea() // Ensures the content extends to the edges of the screen
                        .frame(minHeight: geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets
                            .bottom
                        ) // Set the height of each page
                }
            }
            .frame(width: geometry.size.width) // Set the width of the scrollable area to match the screen width
        }
    }

    private func computeVisibility(geometry: GeometryProxy, page: TModel, container: GeometryProxy) -> TModel? {
        let frame = geometry.frame(in: .global)
        let containerMid: CGFloat = axis == .horizontal
            ? container.frame(in: .global).midX
            : container.frame(in: .global).midY
        let pageMid: CGFloat = axis == .horizontal ? frame.midX : frame.midY
        let threshold: CGFloat = axis == .horizontal ? frame.width / 2 : frame.height / 2
        let isCentered = abs(pageMid - containerMid) < threshold
        return isCentered ? page : nil
    }
}

private struct VisiblePagePreferenceKey: PreferenceKey {
    static var defaultValue: AnyHashable?

    static func reduce(value: inout AnyHashable?, nextValue: () -> AnyHashable?) {
        if let next = nextValue() {
            value = next
        }
    }
}
