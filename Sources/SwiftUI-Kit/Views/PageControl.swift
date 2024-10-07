//===--- PageControl.swift ---------------------------------------===//
//
// This source file is part of the SwiftUIKit open source project
//
// Copyright (c) 2024 You are launched
// Licensed under MIT License
//
// See https://opensource.org/licenses/MIT for license information
//
//===----------------------------------------------------------------------===//

#if canImport(UIKit)
import SwiftUI

/// A SwiftUI wrapper for `UIPageControl` to display and control a page-based interface.
public struct PageControl: UIViewRepresentable {
    public var numberOfPages: Int
    @Binding public var currentPage: Int
    
    /// Creates a `PageControl`.
    /// - Parameters:
    ///   - numberOfPages: The total number of pages to display in the page control.
    ///   - currentPage: A binding to the current page index.
    public init(numberOfPages: Int, currentPage: Binding<Int>) {
        self.numberOfPages = numberOfPages
        self._currentPage = currentPage
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)
        control.currentPageIndicatorTintColor = UIColor.white
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateCurrentPage(sender:)),
            for: .valueChanged
        )
        
        return control
    }
    
    public func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
    
    /// A coordinator class to manage changes to the page control's current page.
    public final class Coordinator: NSObject {
        var control: PageControl
        
        init(_ control: PageControl) {
            self.control = control
        }
        
        /// Updates the current page when the page control value changes.
        @objc
        func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}
#endif
