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
    var attachments: [Attachment] = []
    
    /// Creates a `MailView` to compose and send an email.
    /// - Parameters:
    ///   - result: A binding to capture the result of the mail composition. It is set to `.success(())` if the email is sent, or to `.failure(Error)` if an error occurs.
    ///   - recepients: An optional list of recipient email addresses. Default is `nil`.
    ///   - subject: The subject of the email. Default is an empty string.
    ///   - body: The body text of the email. Default is an empty string.
    ///   - attachments: Array of attachments to include in the email. Each attachment should provide the file data, MIME type, and filename
    public init(result: Binding<Result<Void, Error>?>, recepients: [String]? = nil, subject: String = "", body: String = "", attachments: [Attachment] = []) {
        self._result = result
        self.recepients = recepients
        self.subject = subject
        self.body = body
        self.attachments = attachments
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
        for attachment in attachments {
            vc.addAttachmentData(
                attachment.data,
                mimeType: attachment.mimeType.rawValue,
                fileName: attachment.fileName
            )
        }
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    /// Represents a file attachment to include in an email message.
    ///
    /// Use this type to provide file data along with its corresponding MIME type
    /// and filename when adding attachments to a `MailView`.
    public struct Attachment {
        fileprivate let data: Data
        fileprivate let mimeType: MimeType
        fileprivate let fileName: String

        public init(data: Data, mimeType: MimeType, fileName: String) {
            self.data = data
            self.mimeType = mimeType
            self.fileName = fileName
        }
        
        /// Supported MIME types for email attachments.
        public enum MimeType: String {
            case pdf = "application/pdf"
            case csv = "text/csv"
            case text = "text/plain"
            case gif = "image/gif"
            case jpeg = "image/jpeg"
            case png = "image/png"
            case imageWebp = "image/webp"
            case mp4 = "video/mp4"
            case mpeg = "video/mpeg"
            case zip = "application/zip"
            case octetStream = "application/octet-stream"
        }
    }
}

#endif
