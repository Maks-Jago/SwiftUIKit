//===--- MailView.swift ------------------------------------------===//
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
import MessageUI

/// A SwiftUI wrapper for `MFMailComposeViewController` to present a mail composition interface.
public struct MailView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentation
    @Binding var result: Result<Void, Error>?
    
    var recepients: [String]?
    var subject: String
    var body: String
    
    /// Creates a `MailView` to compose and send an email.
    /// - Parameters:
    ///   - result: A binding to capture the result of the mail composition. It is set to `.success(())` if the email is sent, or to `.failure(Error)` if an error occurs.
    ///   - recepients: An optional list of recipient email addresses. Default is `nil`.
    ///   - subject: The subject of the email. Default is an empty string.
    ///   - body: The body text of the email. Default is an empty string.
    public init(result: Binding<Result<Void, Error>?>, recepients: [String]? = nil, subject: String = "", body: String = "") {
        self._result = result
        self.recepients = recepients
        self.subject = subject
        self.body = body
    }
    
    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var presentation: PresentationMode
        @Binding var result: Result<Void, Error>?
        
        init(presentation: Binding<PresentationMode>, result: Binding<Result<Void, Error>?>) {
            _presentation = presentation
            _result = result
        }
        
        public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error = error {
                self.result = .failure(error)
            } else if case .sent = result {
                self.result = .success(())
            }
            
            controller.dismiss(animated: true, completion: nil)
            $presentation.wrappedValue.dismiss()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation, result: $result)
    }
    
    public func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(recepients)
        vc.setSubject(subject)
        vc.setMessageBody(body, isHTML: false)
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}

#endif
