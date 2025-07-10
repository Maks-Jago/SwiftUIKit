//
//  SwiftUIPagerView.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 09.07.2025.
//

import SwiftUI

/// A pager view component that allows users to swipe between pages. The `SwiftUIPagerView` adapts its behavior based on the iOS version to
/// provide a smooth paging experience.
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
///     SwiftUIPagerView(pages: [PageModel(id: 0, title: "Page 1"), PageModel(id: 1, title: "Page 2")], currentItem: $currentPage) { page in
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
///   - currentItem: A binding to the currently selected page item.
///   - builder: A closure that defines the view for each page.
@available(iOS 14.0, *)
public struct SwiftUIPagerView<TModel: Hashable, TView: View>: View {
    // Tracks if the list has new pages loaded
    @State private var hasNewPages: Bool = false

    @State private var currentIndex: Int = 0

    public var pages: [TModel]
    @Binding public var currentItem: TModel
    public var builder: (TModel) -> TView

    /// Initializes a `SwiftUIPagerView`.
    /// - Parameters:
    ///   - pages: An array of pages to display.
    ///   - currentItem: A binding to the currently selected page.
    ///   - builder: A closure that returns a view for each page.
    public init(pages: [TModel], currentItem: Binding<TModel>, @ViewBuilder builder: @escaping (TModel) -> TView) {
        self.pages = pages
        self._currentItem = currentItem
        self.builder = builder
    }

    public var body: some View {
        GeometryReader { geometry in
            if #available(iOS 17.0, *) {
                // Vertical scroll view that supports paging
                ScrollView(.vertical, showsIndicators: false) {
                    // LazyVStack is used for efficient rendering, only loading pages that are visible
                    LazyVStack(spacing: 0) {
                        ForEach(self.pages, id: \.self) { page in
                            // Build each page using the provided builder
                            self.builder(page)
                                .id(page) // Assigns a unique ID to each page for scrolling and layout purposes
                                .edgesIgnoringSafeArea(.all) // Ensures the content extends to the edges of the screen
                                .frame(
                                    minHeight: geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets
                                        .bottom
                                ) // Set the height of each page
                        }
                    }
                    .scrollTargetLayout() // Optimizes the layout for smooth scrolling
                    .frame(width: geometry.size.width) // Set the width of the scrollable area to match the screen width
                }
                .edgesIgnoringSafeArea(.all) // The scroll view extends to the edges of the screen
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
            } else {
                // Wrapper for using UIScrollView, which allows for paging in older versions of iOS (pre-iOS 17)
                VerticalPagingScrollView(page: $currentIndex) {
                    // LazyVStack for efficiently displaying the list of pages
                    LazyVStack(spacing: 0) {
                        ForEach(self.pages, id: \.self) { page in
                            // Building each page using the provided builder closure
                            self.builder(page)
                                .edgesIgnoringSafeArea(.all) // Extending the content to the edges of the screen
                                .frame(
                                    height: geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets
                                        .bottom
                                ) // Set the height of each page
                        }
                    }
                    .frame(width: geometry.size.width) // Set the width of the stack to match the screen width
                }
                .edgesIgnoringSafeArea(.all) // The UIScrollView extends to the edges of the screen
                // When the currentIndex changes, update the current item based on the new index
                .onChange(of: currentIndex) { ind in
                    currentItem = pages[ind] // Set the current item to the page at the new index
                }
            }
        }
    }
}
