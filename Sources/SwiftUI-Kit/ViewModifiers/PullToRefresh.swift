//
//  PullToRefresh.swift
//  
//
//  Created by Max Kuznetsov on 16.02.2022.
//

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

    @ViewBuilder
    func pullToRefresh(isRefreshing: Binding<Bool>) -> some View {
        if #available(iOS 15,macOS 12.0, *) {
            self.modifier(PullToRefreshModifier(isRefreshing: isRefreshing))
        } else {
            self
        }
    }
}
