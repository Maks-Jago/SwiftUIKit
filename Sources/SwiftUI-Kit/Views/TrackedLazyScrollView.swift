//
//  TrackedLazyScrollView.swift
//  SwiftUI-Kit
//
//  Created by Max Kuznetsov on 29.04.2025.
//

import SwiftUI

// MARK: - Preference value to represent item ID and frame
public struct ItemFramePreference: Equatable {
    public let id: String
    public let frame: CGRect

    public init(id: String, frame: CGRect) {
        self.id = id
        self.frame = frame
    }
}

// MARK: - Non-generic preference key for tracking frames
public struct ItemFramesKey: PreferenceKey {
    public static var defaultValue: [ItemFramePreference] = []

    public static func reduce(value: inout [ItemFramePreference], nextValue: () -> [ItemFramePreference]) {
        value.append(contentsOf: nextValue())
    }
}

// MARK: - Trackable item view using string ID
public struct TrackableItemView<Content: View>: View {
    public let id: String
    public let content: () -> Content

    public init(id: String, @ViewBuilder content: @escaping () -> Content) {
        self.id = id
        self.content = content
    }

    public var body: some View {
        content()
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(
                            key: ItemFramesKey.self,
                            value: [ItemFramePreference(id: id, frame: geo.frame(in: .named("scrollArea")))]
                        )
                }
            )
    }
}

// MARK: - Generic public VisibilityTracker
@available(iOS 17.0, *)
public struct TrackedLazyScrollView<Item: Identifiable, Content: View, Header: View>: View
where Item.ID: LosslessStringConvertible & Hashable {

    public let items: [Item]
    public let header: () -> Header
    public let content: (Item) -> Content
    public let onVisibilityChange: (Set<Item.ID>) -> Void
    public let coordinateSpaceName: String = "scrollArea"
    public let initialItemID: Item.ID?

    @State private var scrollFrame: CGRect = .zero
    @State private var scrollTarget: Item.ID?
    @State private var didSetInitial = false

    // MARK: - Init (without header)
    public init(
        items: [Item],
        initialItemID: Item.ID? = nil,
        @ViewBuilder content: @escaping (Item) -> Content,
        onVisibilityChange: @escaping (Set<Item.ID>) -> Void
    ) where Header == EmptyView {
        self.items = items
        self.initialItemID = initialItemID
        self.content = content
        self.onVisibilityChange = onVisibilityChange
        self.header = { EmptyView() }
    }

    // MARK: - Init (with header)
    public init(
        items: [Item],
        initialItemID: Item.ID? = nil,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping (Item) -> Content,
        onVisibilityChange: @escaping (Set<Item.ID>) -> Void
    ) {
        self.items = items
        self.initialItemID = initialItemID
        self.content = content
        self.onVisibilityChange = onVisibilityChange
        self.header = header
    }

    public var body: some View {
        ScrollView {
            header()

            LazyVStack(spacing: 0) {
                ForEach(items) { item in
                    TrackableItemView(id: String(item.id)) {
                        content(item)
                    }
                    .id(item.id)
                }
            }
            .scrollTargetLayout()
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: geo.frame(in: .named(coordinateSpaceName))) { new in
                            scrollFrame = new
                        }
                }
            )
        }
        .scrollTargetBehavior(.paging)
        .defaultScrollAnchor(.top)
        .scrollIndicators(.automatic)
        .scrollClipDisabled(false)
        .scrollPosition(id: $scrollTarget)
        .coordinateSpace(name: coordinateSpaceName)
        .onPreferenceChange(ItemFramesKey.self) { itemFrames in
            let visible = itemFrames
                .filter { scrollFrame.intersects($0.frame) }
                .compactMap { Item.ID($0.id) }
            onVisibilityChange(Set(visible))
        }
        .onAppear {
            setInitialIfNeeded()
        }
        .onChange(of: items.map(\.id)) { _, _ in
            setInitialIfNeeded()
        }
    }

    private func setInitialIfNeeded() {
        guard !didSetInitial, let target = initialItemID,
              items.contains(where: { $0.id == target }) else { return }

        didSetInitial = true
        // Disable animation when jumping to initial item
        withAnimation(nil) {
            scrollTarget = target
        }
    }
}
