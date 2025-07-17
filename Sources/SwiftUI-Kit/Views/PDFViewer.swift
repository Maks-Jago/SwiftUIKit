//
//  PDFViewer.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 08.07.2025.
//

import PDFKit
import SwiftUI

/// A SwiftUI wrapper for displaying PDF documents using `PDFView`.
public struct PDFViewer: UIViewRepresentable {
    var url: URL?
    var data: Data?

    /// Initializes the viewer with a file URL to a PDF.
    public init(url: URL?) {
        self.url = url
    }

    /// Initializes the viewer with raw PDF data.
    public init(data: Data?) {
        self.data = data
    }

    /// Creates the `PDFView` instance and configures it with the initial document.
    public func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()

        if let url {
            pdfView.document = PDFDocument(url: url)
            pdfView.autoScales = true // Automatically scale the PDF to fit the view.
        } else if let data {
            pdfView.document = PDFDocument(data: data)
            pdfView.autoScales = true
        }

        return pdfView
    }

    /// Updates the `PDFView` when SwiftUI state changes.
    public func updateUIView(_ uiView: PDFView, context: Context) {
        // If a new URL is provided, update the document.
        if let url {
            uiView.document = PDFDocument(url: url)
        }

        // Force the view to reload layout/input state.
        uiView.reloadInputViews()
    }
}
