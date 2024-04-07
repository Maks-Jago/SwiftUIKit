//
//  SocialAuthData.swift
//  SwiftUIKit
//
//  Created by Lena Soroka on 07.04.2024.
//

import Foundation

struct SocialAuthData: Equatable {
    let token: Data
    let firstName: String?
    let lastName: String?
    var email: String?
    var avatarUrl: String? = nil
    let provider: AuthProvider
    var authorizationCode: Data? = nil
}

extension SocialAuthData {
    var authorizationCodeString: String {
        if let authorizationCode {
            return String(data: authorizationCode, encoding: .utf8) ?? ""
        }
        return ""
    }
}

public enum AuthProvider: String, Codable, Equatable {
    case temp
    case email
    case apple
    case google
}
