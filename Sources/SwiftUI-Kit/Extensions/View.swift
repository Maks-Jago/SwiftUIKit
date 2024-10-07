//===--- View+Extensions.swift -----------------------------------===//
//
// This source file is part of the SwiftUI-Kit open source project
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
