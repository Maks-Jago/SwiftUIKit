//
//  DropdownPicker.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 07.07.2025.
//

import SwiftUI

/// A customizable dropdown picker view that displays a list of selectable items in a collapsible menu.
///
/// This view mimics a dropdown selector, presenting a list of items conforming to `DropdownItemProtocol`.
/// When collapsed, it shows the currently selected item and an optional arrow. When tapped, it expands to
/// reveal a scrollable list of items for selection. Selecting an item updates the binding and collapses the menu.
@available(iOS 15.0, *)
public struct DropdownPicker<Item: DropdownItemProtocol>: View {
    @Binding private var selectedItem: Item

    private let items: [Item]
    private let itemListRowHeight: CGFloat
    private let maxRowsCount: Int
    private let textColor: Color
    private let textFont: Font
    private let arrowImage: Image?
    private let arrowColor: Color
    private let separatorColor: Color

    @State private var isExpanded: Bool = false

    /// Creates a new dropdown picker with the specified configuration.
    ///
    /// - Parameters:
    ///   - selectedItem: A binding to the currently selected item.
    ///   - items: The list of items to choose from.
    ///   - itemListRowHeight: Height for each row in the list (default is 44).
    ///   - maxRowsCount: Maximum number of visible items before scrolling (default is 7).
    ///   - textColor: Text color for item names.
    ///   - textFont: Font used for item text.
    ///   - arrowImage: Optional image for the dropdown arrow.
    ///   - arrowColor: Color of the dropdown arrow.
    ///   - separatorColor: Color of separator lines between items.
    public init(
        selectedItem: Binding<Item>,
        items: [Item],
        itemListRowHeight: CGFloat = 44,
        maxRowsCount: Int = 7,
        textColor: Color = .black,
        textFont: Font = .body,
        arrowImage: Image? = nil,
        arrowColor: Color = .blue,
        separatorColor: Color = .black
    ) {
        self._selectedItem = selectedItem
        self.items = items
        self.itemListRowHeight = itemListRowHeight
        self.maxRowsCount = maxRowsCount
        self.textColor = textColor
        self.textFont = textFont
        self.arrowImage = arrowImage
        self.arrowColor = arrowColor
        self.separatorColor = separatorColor
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack {
                Text(selectedItem.name)
                    .font(textFont)
                    .foregroundStyle(textColor)
                Spacer()
                if let arrowImage {
                    arrowImage
                        .template
                        .aspectFit()
                        .frame(20)
                        .foregroundStyle(arrowColor)
                        .rotationEffect(.degrees(isExpanded ? -180 : 0))
                }
            }
            .padding(.horizontal)
            .frame(height: itemListRowHeight)
            .embedInPlainButton {
                withAnimation(.smooth(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                itemsList
            }
        }
    }
}

/// A view representing the list of items shown when the dropdown is expanded.
/// Includes a separator and a tappable row for each item. Selecting an item updates the binding and collapses the dropdown.
@available(iOS 15.0, *)
private extension DropdownPicker {
    var itemsList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: .zero) {
                ForEach(items) { item in
                    separatorColor
                        .frame(maxWidth: .infinity, maxHeight: 1)

                    HStack(spacing: .zero) {
                        Text(item.name)
                            .font(textFont)
                            .foregroundStyle(textColor)
                            .frame(height: itemListRowHeight)
                        Spacer(minLength: .zero)
                    }
                    .padding(.horizontal)
                    .embedInPlainButton {
                        withAnimation(.smooth(duration: 0.3)) {
                            if selectedItem.id != item.id {
                                selectedItem = item
                            }
                            isExpanded.toggle()
                        }
                    }
                }
            }
        }
        .frame(height: itemsListHeight)
    }
}

/// Computes the dynamic height of the item list based on the number of items and the maximum allowed row count.
@available(iOS 15.0, *)
private extension DropdownPicker {
    var itemsListHeight: CGFloat {
        isExpanded ? (itemListRowHeight + 1) * CGFloat(min(items.count, maxRowsCount)) : 0
    }
}

/// A protocol that represents an identifiable dropdown item with a displayable name.
public protocol DropdownItemProtocol: Identifiable {
    var name: String { get }
}
