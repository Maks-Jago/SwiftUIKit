//
//  Alerts.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

public extension View {
    @available(*, deprecated, message: "Use `alert(status: Binding<AlertBuilder.AlertStatus>)` from SwiftUI-UDF instead of `errorAlert`")
    func errorAlert(
        error: Binding<String?>,
        title: String = Bundle.main.localizedString(forKey: "Error", value: nil, table: nil),
        dismissButtonTitle: String = Bundle.main.localizedString(forKey: "Ok", value: nil, table: nil)
    ) -> some View {
        self.alert(item: error) {
            Alert(title: Text(title), message: Text($0), dismissButton: .default(Text(dismissButtonTitle)))
        }
    }
}

public extension View {
    
    @available(*, deprecated, message: "Use `alert(status: Binding<AlertBuilder.AlertStatus>)` from SwiftUI-UDF instead of `messageAlert`")
    func messageAlert(
        message: Binding<String?>,
        title: String = Bundle.main.localizedString(forKey: "Success", value: nil, table: nil),
        dismissButtonTitle: String = Bundle.main.localizedString(forKey: "Ok", value: nil, table: nil)
    ) -> some View {
        self.alert(item: message) {
            Alert(title: Text(title), message: Text($0), dismissButton: .default(Text(dismissButtonTitle)))
        }
    }
}
