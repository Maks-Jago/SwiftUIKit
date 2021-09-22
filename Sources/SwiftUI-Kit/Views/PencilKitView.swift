//
//  PencilKitView.swift
//  SwiftUIKit
//
//  Created by  Vladyslav Fil on 22.09.2021.
//

import SwiftUI
import PencilKit

struct PencilKitView : UIViewRepresentable {
    
    @Binding var canvas: PKCanvasView
    var onChanged: () -> Void = {}
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.delegate = context.coordinator
        canvas.overrideUserInterfaceStyle = .light
        canvas.drawingPolicy = .anyInput
        canvas.tool = PKInkingTool(.pen, color: .black, width: 10)
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(canvas: $canvas, onChanged: onChanged)
    }
}

class Coordinator: NSObject {
    var canvas: Binding<PKCanvasView>
    let onChanged: () -> Void

    init(canvas: Binding<PKCanvasView>, onChanged: @escaping () -> Void) {
        self.canvas = canvas
        self.onChanged = onChanged
    }
}

extension Coordinator: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        onChanged()
    }
}
