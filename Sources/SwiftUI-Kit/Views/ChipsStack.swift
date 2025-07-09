//
//  ChipsStack.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 09.07.2025.
//

import SwiftUI

/// `ChipsStack` is a custom layout that arranges its subviews in a horizontal flow, similar to how chips are displayed in a tag cloud. The
/// layout automatically moves subviews to the next row if they exceed the available width.
///
/// Example usage:
/// ```swift
/// struct ExampleView: View {
///     let items = ["Swift", "UI", "Layout", "Flow", "Tag", "Chips"]
///
///     var body: some View {
///         ChipsStack(spacing: 8) {
///             ForEach(items, id: \.self) { item in
///                 Text(item)
///                     .padding(.horizontal, 12)
///                     .padding(.vertical, 6)
///                     .background(Color.blue.opacity(0.3))
///                     .cornerRadius(16)
///             }
///         }
///     }
/// }
/// ```
///
/// - Parameters:
///   - spacing: The space between each chip. Defaults to 8.
@available(iOS 16.0, *)
public struct ChipsStack: Layout {
    private let spacing: CGFloat

    /// Initializes a `ChipsStack` layout with optional spacing between chips.
    /// - Parameter spacing: The space between each chip. Defaults to 8.
    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }

    /// Calculates the size that fits the proposed size by arranging the subviews in a row and moving them to a new row when necessary.
    /// - Parameters:
    ///   - proposal: The size that the layout should fit within.
    ///   - subviews: The subviews to be arranged within the layout.
    ///   - cache: A cache for storing layout data.
    /// - Returns: The total size required to fit all the subviews.
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        let maxViewHeight = sizes.map(\.height).max() ?? 0
        var currentRowWidth: CGFloat = 0
        var totalHeight: CGFloat = maxViewHeight
        var totalWidth: CGFloat = 0

        for size in sizes {
            // If the current row's width exceeds the proposal width, start a new row.
            if currentRowWidth + spacing + size.width > proposal.width ?? 0 {
                totalHeight += spacing + maxViewHeight
                currentRowWidth = size.width
            } else {
                currentRowWidth += spacing + size.width
            }
            // Track the maximum width used by the layout.
            totalWidth = max(totalWidth, currentRowWidth)
        }
        return CGSize(width: totalWidth, height: totalHeight)
    }

    /// Places the subviews within the specified bounds, arranging them in rows based on the available width.
    /// - Parameters:
    ///   - bounds: The area in which the subviews should be placed.
    ///   - proposal: The proposed size for placing the subviews.
    ///   - subviews: The subviews to be placed.
    ///   - cache: A cache for storing layout data.
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        let maxViewHeight = sizes.map(\.height).max() ?? 0
        var point = CGPoint(x: bounds.minX, y: bounds.minY)

        for index in subviews.indices {
            // Move to the next row if the current subview exceeds the bounds' width.
            if point.x + sizes[index].width > bounds.maxX {
                point.x = bounds.minX
                point.y += maxViewHeight + spacing
            }
            // Place the subview at the current point.
            subviews[index].place(at: point, proposal: ProposedViewSize(sizes[index]))
            point.x += sizes[index].width + spacing
        }
    }
}
