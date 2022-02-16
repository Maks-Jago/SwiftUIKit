//
//  PullToRefresh.swift
//  
//
//  Created by Max Kuznetsov on 16.02.2022.
//

import Foundation
import SwiftUI
import Combine

@available(iOS 15, *)
fileprivate struct PullToRefreshModifier: ViewModifier {
    @Binding var isRefreshing: Bool
    @StateObject var handler = ContinuationHandler()

    func body(content: Content) -> some View {
        content.refreshable {
            await withUnsafeContinuation { (continuation: UnsafeContinuation<Void, Never>) in
                handler.continuation = continuation
                isRefreshing = true
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
        if #available(iOS 15, *) {
            self.modifier(PullToRefreshModifier(isRefreshing: isRefreshing))
        } else {
            self
        }
    }
}
