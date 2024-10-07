//===--- PencilKitView.swift -------------------------------------===//
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
import PencilKit
#if os(iOS)

@available(iOS 14, *)
/// A SwiftUI wrapper for `PKCanvasView`, allowing users to draw using PencilKit.
public struct PencilKitView: UIViewRepresentable {
    
    @Binding var canvas: PKCanvasView
    var onChanged: () -> Void
    
    /// Creates a `PencilKitView`.
    /// - Parameters:
    ///   - canvas: A binding to a `PKCanvasView` that provides the drawing canvas.
    ///   - onChanged: A closure called whenever the canvas drawing changes. Default is an empty closure.
    public init(canvas: Binding<PKCanvasView>, onChanged: @escaping () -> Void = {}) {
        self._canvas = canvas
        self.onChanged = onChanged
    }
    
    public func makeUIView(context: Context) -> PKCanvasView {
        canvas.delegate = context.coordinator
        canvas.overrideUserInterfaceStyle = .light
        canvas.drawingPolicy = .anyInput
        canvas.tool = PKInkingTool(.pen, color: .black, width: 10)
        return canvas
    }
    
    public func updateUIView(_ uiView: PKCanvasView, context: Context) { }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(canvas: $canvas, onChanged: onChanged)
    }
}

/// A coordinator to handle `PKCanvasView` delegate methods.
public class Coordinator: NSObject {
    var canvas: Binding<PKCanvasView>
    let onChanged: () -> Void
    
    /// Initializes a `Coordinator`.
    /// - Parameters:
    ///   - canvas: A binding to the `PKCanvasView`.
    ///   - onChanged: A closure to call when the canvas drawing changes.
    init(canvas: Binding<PKCanvasView>, onChanged: @escaping () -> Void) {
        self.canvas = canvas
        self.onChanged = onChanged
    }
}

extension Coordinator: PKCanvasViewDelegate {
    
    /// Called when the drawing on the canvas view changes.
    /// - Parameter canvasView: The `PKCanvasView` whose drawing has changed.
    public func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        onChanged()
    }
}
#endif
