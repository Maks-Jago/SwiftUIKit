//===--- View+Extensions.swift -----------------------------------===//
//
// This source file is part of the SwiftUIKit open source project
//
// Copyright (c) 2024 You are launched
// Licensed under MIT License
//
// See https://opensource.org/licenses/MIT for license information
//
//===----------------------------------------------------------------------===//

import SwiftUI
import Combine

#if canImport(UIKit)
public extension View {
    
    /// Adds an on-tap gesture to the view with an optional animation.
    /// - Parameters:
    ///   - animation: The animation to apply when the gesture is performed. Default is `.easeInOut`.
    ///   - perform: The action to perform when the tap gesture is detected.
    /// - Returns: A modified view that triggers the action with animation on tap.
    func onTapGestureWithAnimation(_ animation: Animation = .easeInOut, perform: @escaping () -> Void) -> some View {
        self.onTapGesture {
            withAnimation(animation, perform)
        }
    }
    
    /// Prints a specified value to the console for debugging purposes.
    /// - Parameter value: The value to print.
    /// - Returns: The original view.
    func printValue<V>(_ value: V) -> some View {
        print("\(value)")
        return self
    }
    
    /// Dismisses the keyboard when the view is tapped.
    /// - Returns: A modified view that hides the keyboard on tap.
    func hideKeyboardByTap() -> some View {
        self.onTapGesture {
            obtainKeyWindow()?.endEditing(true)
        }
    }
}
#endif

public extension View {
    
    /// Conditionally applies a transformation to the view.
    /// - Parameters:
    ///   - condition: A Boolean value that determines whether to apply the transformation.
    ///   - transform: A closure that modifies the view if the condition is true.
    /// - Returns: The original or transformed view based on the condition.
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Conditionally applies a transformation to the view using a closure to evaluate the condition.
    /// - Parameters:
    ///   - condition: A closure that returns a Boolean value to determine whether to apply the transformation.
    ///   - transform: A closure that modifies the view if the condition is true.
    /// - Returns: The original or transformed view based on the condition.
    @ViewBuilder
    func `if`<Transform: View>(_ condition: () -> Bool, transform: (Self) -> Transform) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
    
    /// Conditionally applies one of two transformations to the view.
    /// - Parameters:
    ///   - condition: A Boolean value that determines which transformation to apply.
    ///   - transform: A closure that modifies the view if the condition is true.
    ///   - elseTransform: A closure that modifies the view if the condition is false.
    /// - Returns: The modified view based on the condition.
    @ViewBuilder
    func `if`<TransformIf: View, TransformElse: View>(
        _ condition: Bool,
        transform: (Self) -> TransformIf,
        else elseTransform: (Self) -> TransformElse
    ) -> some View {
        if condition {
            transform(self)
        } else {
            elseTransform(self)
        }
    }
    
    /// Conditionally applies one of two transformations to the view using a closure to evaluate the condition.
    /// - Parameters:
    ///   - condition: A closure that returns a Boolean value to determine which transformation to apply.
    ///   - transform: A closure that modifies the view if the condition is true.
    ///   - elseTransform: A closure that modifies the view if the condition is false.
    /// - Returns: The modified view based on the condition.
    @ViewBuilder
    func `if`<TransformIf: View, TransformElse: View>(
        _ condition: () -> Bool,
        transform: (Self) -> TransformIf,
        else elseTransform: (Self) -> TransformElse
    ) -> some View {
        if condition() {
            transform(self)
        } else {
            elseTransform(self)
        }
    }
    
    /// Conditionally applies a transformation to the view if an optional value is non-nil.
    /// - Parameters:
    ///   - optional: The optional value to check.
    ///   - transform: A closure that modifies the view if the optional value is non-nil.
    /// - Returns: The modified view based on the presence of the optional value.
    @ViewBuilder
    func `ifLet`<T, Transform: View>(_ optional: T?, transform: (Self, T) -> Transform) -> some View {
        if let unwrapped = optional {
            transform(self, unwrapped)
        } else {
            self
        }
    }
}

public extension View where Self: Equatable {
    
    /// Converts the view to an `EquatableView`, which optimizes view updates by comparing the previous and current states.
    /// - Returns: An `EquatableView` containing the current view.
    func equatable() -> EquatableView<Self> {
        EquatableView(content: self)
    }
}

#if os(iOS)
// MARK: - Hide Navigation Bar
public extension View {
    
    /// Hides the navigation bar for the view.
    /// - Parameter backButtonHidden: A Boolean value that determines whether the back button is hidden. Default is `true`.
    /// - Returns: A modified view with the navigation bar hidden.
    func hideNavigationBar(backButtonHidden: Bool = true) -> some View {
        self
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(backButtonHidden)
    }
}

// MARK: - Keyboard Avoiding Padding
public extension View {
    
    /// Adds padding to avoid the keyboard.
    /// - Parameter bottomInset: The bottom inset to consider when adding padding. Default is `0`.
    /// - Returns: A modified view that adjusts padding based on the keyboard's visibility.
    func keyboardAvoidingPadding(bottomInset: CGFloat = 0) -> some View {
        ModifiedContent(content: self, modifier: KeyboardPaddingModifier(bottomInset: bottomInset))
    }
}

private struct KeyboardPaddingModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    @State private var animatedKeyboard: Bool = false
    var bottomInset: CGFloat = 0
    @State private var ignoreBottomInset = false
    
    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
                .map { $0.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        ).eraseToAnyPublisher()
    }
    
    private var animatedKeyboardPublisher: AnyPublisher<Bool, Never> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
            .eraseToAnyPublisher()
    }
    
    func body(content: Content) -> some View {
        Group {
            if #available(iOS 14, *) {
                content
            } else {
                content
                    .padding(.bottom, max(0, keyboardHeight - (ignoreBottomInset ? (bottomInset > 0 ? 40 : 0) : bottomInset)))
                    .edgesIgnoringSafeArea(keyboardHeight > 0 ? [.bottom] : [])
                    .animation(.easeOut(duration: animatedKeyboard ? 0.25 : 0))
                    .onReceive(keyboardHeightPublisher) {
                        self.ignoreBottomInset = $0 < 300
                        self.keyboardHeight = $0
                    }
                    .onReceive(animatedKeyboardPublisher) { self.animatedKeyboard = $0 }
            }
        }
    }
}

#endif

// MARK: - Clickable Clear Background
public extension View {
    
    /// Adds a clear, clickable background to the view.
    /// - Returns: A modified view with a transparent background that can be clicked.
    func clickableClearBackground() -> some View {
        self
            .background(Color.white.opacity(0.00000001))
    }
}

// MARK: - Placeholder
public extension View {
    
    /// Displays a placeholder view when a condition is met.
    /// - Parameters:
    ///   - shouldShow: A Boolean value that determines whether to show the placeholder.
    ///   - alignment: The alignment of the placeholder within the view. Default is `.leading`.
    ///   - placeholder: A view builder that creates the placeholder view.
    /// - Returns: A modified view that overlays the placeholder based on the condition.
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    /// Displays a full screen placeholder view when a condition is met.
    /// - Parameters:
    ///   - shouldShow: A Boolean value that determines whether to show the placeholder.
    ///   - alignment: The alignment of the placeholder within the view. Default is `.center`.
    ///   - placeholder: A view builder that creates the placeholder view.
    /// - Returns: A modified view that overlays the placeholder based on the condition.
    func fullScreenPlaceholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .center,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            self.opacity(shouldShow ? 0 : 1)
            if shouldShow {
                placeholder().opacity(shouldShow ? 1 : 0)
            }
        }
    }
}

// MARK: - Fixed Size
public extension View {
    
    /// Fixes the width of the view.
    /// - Returns: A modified view with a fixed width.
    func fixedWidth() -> some View {
        fixedSize(horizontal: true, vertical: false)
    }
    
    /// Fixes the height of the view.
    /// - Returns: A modified view with a fixed height.
    func fixedHeight() -> some View {
        fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Frame
public extension View {
    
    /// Sets a fixed width and height for the view.
    /// - Parameters:
    ///   - widthAndHeight: The value to set for both the width and height.
    ///   - alignment: The alignment of the view within its frame. Default is `.center`.
    /// - Returns: A modified view with the specified width and height.
    func frame(_ widthAndHeight: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: widthAndHeight, height: widthAndHeight, alignment: alignment)
    }
    
    /// Sets a fixed size for the view using a `CGSize`.
    /// - Parameters:
    ///   - size: The `CGSize` to use for the view's width and height.
    ///   - alignment: The alignment of the view within its frame. Default is `.center`.
    /// - Returns: A modified view with the specified size.
    func frame(_ size: CGSize, alignment: Alignment = .center) -> some View {
        frame(width: size.width, height: size.height, alignment: alignment)
    }
}

// MARK: - Popup Overlay
public extension View {
    /// Presents a popup overlay based on a bound optional item. When the item is non-nil, a customizable popup view is shown.
    ///
    /// This method uses an overlay with a semi-transparent background and displays a view constructed by the provided `builder`
    /// closure. The popup supports animated presentation and dismissal, including tapping outside to dismiss.
    ///
    /// - Parameters:
    ///   - item: A `Binding` to an optional item that controls the visibility of the popup. When the item is non-nil, the popup is shown.
    ///   - builder: A closure that takes the unwrapped item and a dismiss action, returning the popup content as a `View`.
    /// - Returns: A modified `View` that conditionally presents a popup overlay when the bound item is non-nil.
    @available(iOS 15.0, *)
    func popupOverlay<Item: Equatable>(
        item: Binding<Item?>,
        builder: @escaping (Item, @escaping () -> Void) -> some View
    ) -> some View {
        overlay {
            ZStack {
                if let unwrappedItem = item.wrappedValue {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            // Dismiss the overlay by setting the item to nil
                            withAnimation(.easeInOut(duration: 0.2)) {
                                item.wrappedValue = nil
                            }
                        }

                    // Pass the dismiss function to the builder
                    builder(unwrappedItem) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            item.wrappedValue = nil
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .ignoresSafeArea()
            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: item.wrappedValue)
        }
    }
}

// MARK: Read & Offset
public extension View {
    /// Reads the position of a view within a specified coordinate space and updates the provided binding with the calculated position.
    /// - Parameters:
    ///   - position: A binding to a `CGPoint` that will be updated with the view's position.
    ///   - coordinateSpace: The `CoordinateSpace` in which the view's position should be measured.
    /// - Returns: A view that reads its position and updates the binding accordingly.
    @available(iOS 15.0, *)
    func read(_ position: Binding<CGPoint>, in coordinateSpace: CoordinateSpace) -> some View {
        background {
            GeometryReader { geometry in
                // Using a nearly invisible background to trigger the GeometryReader
                Color.white.opacity(0.000001)
                    .preference(key: RectPreferenceKey.self, value: geometry.frame(in: coordinateSpace))
                    .onPreferenceChange(RectPreferenceKey.self) { frame in
                        withAnimation {
                            position.wrappedValue = .init(x: frame.midX, y: frame.midY)
                        }
                    }
            }
        }
    }

    /// Tracks the offset of the current view within the specified coordinate space.
    ///
    /// This method adds an overlay using `GeometryReader` to compute the `minY` offset of the view within the given coordinate space. The
    /// offset value is then passed to the provided completion handler.
    ///
    /// - Parameters:
    ///   - coordinateSpace: The `CoordinateSpace` in which the view's position is to be measured.
    ///   - completion: A closure that receives the computed `minY` offset value.
    /// - Returns: A modified `View` that provides the offset value of its position within the specified coordinate space.
    @available(iOS 15.0, *)
    func offset(
        coordinateSpace: CoordinateSpace,
        completion: @escaping (CGFloat) -> Void
    ) -> some View {
        overlay {
            GeometryReader { proxy in
                let minY = proxy.frame(in: coordinateSpace).minY
                Color.clear
                    .preference(key: OffsetPreferenceKey.self, value: minY)
                    .onPreferenceChange(OffsetPreferenceKey.self) { value in
                        completion(value)
                    }
            }
        }
    }

    /// Reads the size of a view and updates the provided binding with the calculated size.
    ///
    /// This method uses a `GeometryReader` placed in the background to measure the view’s size.
    /// The size is then passed to the specified `Binding<CGSize>`, allowing external state to react
    /// to layout changes or dynamic sizing.
    ///
    /// - Parameter size: A binding to a `CGSize` that will be updated with the view's current size.
    /// - Returns: A view that measures its own size and updates the binding accordingly.
    func read(_ size: Binding<CGSize>) -> some View {
        background(
            GeometryReader { geometry in
                Color.white.opacity(0.000001)
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
                    .onPreferenceChange(SizePreferenceKey.self) { newSize in
                        withAnimation {
                            size.wrappedValue = newSize
                        }
                    }
            }
        )
    }
}

public struct OffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: CGFloat = .zero

    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

public struct RectPreferenceKey: PreferenceKey {
    public static var defaultValue: CGRect = .zero

    /// A function that updates the preference value with the next value.
    public static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

public struct SizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero

    /// A function that updates the preference value with the next value.
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// MARK: Background Rounded Rectangle
public extension View {
    /// Wraps the current view with padding, a background color, and rounded corners.
        ///
        /// This modifier adds padding around the content, applies a background color,
        /// and clips the result with a `RoundedRectangle` to achieve a card-like appearance.
        ///
        /// - Parameters:
        ///   - backgroundColor: The background color to apply. Default is `.white`.
        ///   - cornerRadius: The radius of the rounded corners. Default is `24`.
        ///   - paddingInsets: The padding to apply around the content. Default is `16` points on all sides.
        ///
        /// - Returns: A view with padding, background color, and rounded corners.
    func backgroundRoundedRectangle(
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = 24,
        paddingInsets: EdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    ) -> some View {
        padding(paddingInsets)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
