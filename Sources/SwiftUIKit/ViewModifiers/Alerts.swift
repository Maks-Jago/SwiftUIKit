//
//  Alerts.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

public extension View {
    func errorAlert(error: Binding<String?>, title: String = "Error", dismissButtonTitle: String = "Ok") -> some View {
        self.alert(item: error) {
            Alert(title: Text(title), message: Text($0), dismissButton: .default(Text(dismissButtonTitle)))
        }
    }
}

public extension View {
    func messageAlert(message: Binding<String?>, title: String = "Success", dismissButtonTitle: String = "Ok") -> some View {
        self.alert(item: message) {
            Alert(title: Text(title), message: Text($0), dismissButton: .default(Text(dismissButtonTitle)))
        }
    }
}
