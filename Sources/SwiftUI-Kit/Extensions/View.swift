//
//  View.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI
import Combine

#if canImport(UIKit)
public extension View {
    func onTapGestureWithAnimation(_ animation: Animation = .easeInOut, perform: @escaping () -> Void) -> some View {
        self.onTapGesture {
            withAnimation(animation, perform)
        }
    }

    func printValue<V>(_ value: V) -> some View {
        print("\(value)")
        return self
    }

    func hideKeyboardByTap() -> some View {
        self.onTapGesture {
            obtainKeyWindow()?.endEditing(true)
        }
    }
}
#endif

public extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func `if`<Transform: View>(_ condition: () -> Bool, transform: (Self) -> Transform) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
    
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
}

public extension View where Self: Equatable {
    func equatable() -> EquatableView<Self> {
        EquatableView(content: self)
    }
}
#if os(iOS)

//MARK: - Hide Navigation Bar
public extension View {
    func hideNavigationBar(backButtonHidden: Bool = true) -> some View {
        self
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(backButtonHidden)
    }
}

//MARK: - Keyboard Avoiding Padding
public extension View {
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

//MARK: - Clickable Clear Background
public extension View {
    func clickableClearBackground() -> some View {
        self
            .background(Color.white.opacity(0.00000001))
    }
}

//MARK: - Placeholder
public extension View {
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

//MARK: - Fixed size
public extension View {
    func fixedWidth() -> some View {
        fixedSize(horizontal: true, vertical: false)
    }
    
    func fixedHeight() -> some View {
        fixedSize(horizontal: false, vertical: true)
    }
}

//MARK: - Frame
public extension View {
    func frame(_ widthAndHeight: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: widthAndHeight, height: widthAndHeight, alignment: alignment)
    }
    
    func frame(_ size: CGSize, alignment: Alignment = .center) -> some View {
        frame(width: size.width, height: size.height, alignment: alignment)
    }
}

// MARK: - Read Initial
extension View {
    func readInitial(_ size: Binding<CGSize>) -> some View {
        background(
            GeometryReader { geometry in
                Color.white.opacity(0.000001)
                    .onAppear { size.wrappedValue = geometry.size }
            }
        )
    }
}

// MARK: - ZeroListEdgeRowInsets
extension View {
    func zeroListEdgeRowInsets() -> some View {
        self.listRowInsets(.zero)
    }
}

// MARK: - Read position
extension View {
    @available(iOS 15.0, *)
    func read(_ position: Binding<CGPoint>, in coordinateSpace: CoordinateSpace) -> some View {
        background {
            GeometryReader { geometry in
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
}

struct RectPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}


