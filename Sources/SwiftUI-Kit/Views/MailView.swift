//
//  MailView.swift
//  SwiftUIKit
//
//  Created by  Vladyslav Fil on 22.09.2021.
//

#if canImport(UIKit)
import SwiftUI
import MessageUI

public struct MailView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentation
    @Binding var result: Result<Void, Error>?
    
    var recepients: [String]?
    var subject: String
    var body: String
    
    public init(result: Binding<Result<Void, Error>?>, recepients: [String]? = nil, subject: String = "", body: String = "") {
        self._result = result
        self.recepients = recepients
        self.subject = subject
        self.body = body
    }

    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var presentation: PresentationMode
        @Binding var result: Result<Void, Error>?
        
        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<Void, Error>?>) {
            _presentation = presentation
            _result = result
        }
        
        public func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            if let error = error {
                self.result = .failure(error)
            } else {
                if case .sent = result {
                    self.result = .success(())
                }
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
