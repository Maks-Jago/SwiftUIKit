//
//  WebView.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 09.07.2025.
//

import SwiftUI
import WebKit

/// A SwiftUI wrapper around `WKWebView` that supports loading a URL and tracking loading progress.
public struct WebView: UIViewRepresentable {
    private let url: URL
    @Binding private var progress: Float

    /// Initializes the `WebView` with a URL and a progress binding.
    /// - Parameters:
    ///   - url: The URL to be loaded.
    ///   - progress: A binding to reflect the web view's loading progress (0.0 to 1.0).
    public init(url: URL, progress: Binding<Float>) {
        self.url = url
        self._progress = progress
    }

    /// Creates and configures the underlying `WKWebView`.
    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator // Set delegate to observe navigation events.
        return webView
    }

    /// Updates the web view if needed when the SwiftUI state changes.
    public func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        // Prevent unnecessary reloads; only load if URL changed or still loading.
        if webView.url != url || webView.isLoading {
            DispatchQueue.main.async {
                webView.load(request)
            }
        }
    }

    /// Creates a coordinator instance to act as delegate and observer.
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// A coordinator class to observe navigation and loading progress.
    public class Coordinator: NSObject, WKNavigationDelegate {
        private let parent: WebView

        public init(_ webView: WebView) {
            self.parent = webView
        }

        /// Called when navigation starts. Adds KVO to observe loading progress.
        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            if webView.observationInfo == nil {
                DispatchQueue.main.async {
                    webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
                }
            }
        }

        /// Called when navigation finishes. Removes KVO and sets progress to 100%.
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                webView.removeObserver(self, forKeyPath: "estimatedProgress")
                self.parent.progress = 1.0
            }
        }

        /// Observes the estimated loading progress and updates the binding.
        override public func observeValue(
            forKeyPath keyPath: String?,
            of object: Any?,
            change: [NSKeyValueChangeKey: Any]?,
            context: UnsafeMutableRawPointer?
        ) {
            guard keyPath == "estimatedProgress", let webView = object as? WKWebView else { return }
            DispatchQueue.main.async {
                self.parent.progress = Float(webView.estimatedProgress)
            }
        }
    }
}

