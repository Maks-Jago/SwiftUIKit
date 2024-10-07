//===--- PullToRefresh.swift -------------------------------------===//
//
// This source file is part of the SwiftUIKit open source project
//
// Copyright (c) 2024 You are launched
// Licensed under MIT License
//
// See https://opensource.org/licenses/MIT for license information
//
//===----------------------------------------------------------------------===//

import Foundation
import SwiftUI
import Combine

@available(iOS 15, macOS 12.0, *)
fileprivate struct PullToRefreshModifier: ViewModifier {
    @Binding var isRefreshing: Bool
    @StateObject var handler = ContinuationHandler()
    
    func body(content: Content) -> some View {
        content.refreshable {
            await withUnsafeContinuation { (continuation: UnsafeContinuation<Void, Never>) in
                handler.continuation = continuation
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isRefreshing = true
                }
            }
        }
        .onChange(of: isRefreshing) { [handler] newValue in
            if !newValue, handler.continuation != nil {
                handler.continuation?.resume()
                handler.continuation = nil
            }
        }
    }
}

fileprivate final class ContinuationHandler: ObservableObject {
    var continuation: UnsafeContinuation<Void, Never>?
    
    init() {}
}

public extension View {
    
    /// Adds a pull-to-refresh capability to the view.
    /// - Parameter isRefreshing: A binding that indicates whether a refresh is in progress.
    /// - Returns: A view that supports pull-to-refresh functionality.
    @ViewBuilder
    func pullToRefresh(isRefreshing: Binding<Bool>) -> some View {
        if #available(iOS 15, macOS 12.0, *) {
            self.modifier(PullToRefreshModifier(isRefreshing: isRefreshing))
        } else {
            self
        }
    }
}
