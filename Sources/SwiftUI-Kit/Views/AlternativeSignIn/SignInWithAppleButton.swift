//
//  SignInWithAppleButton.swift
//  SwiftUIKit
//
//  Created by Lena Soroka on 07.04.2024.
//

import SwiftUI
import AuthenticationServices

//MARK: - Sign In With Apple Manager
class SignInWithAppleManager: ObservableObject {
    var resultAction: (Result<SocialAuthData, Error>) -> ()
    private lazy var appleSignInCoordinator = AppleSignInCoordinator(signInManager: self)
        
    init(result: @escaping (Result<SocialAuthData, Error>) -> ()) {
        resultAction = result
    }
    
    func signIn() {
        appleSignInCoordinator.handleAuthorizationAppleIDButtonPress()
    }
}

//MARK: - AppleSignInCoordinator
fileprivate class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate {
    // Backend Service Variable
    var signInManager: SignInWithAppleManager
    
    init(signInManager: SignInWithAppleManager) {
        self.signInManager = signInManager
    }
    
    // Shows Sign in with Apple UI
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    // Delegate methods
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let token = appleIDCredential.identityToken {
                signInManager.resultAction(
                    .success(
                        .init(
                            token: token,
                            firstName: appleIDCredential.fullName?.givenName,
                            lastName: appleIDCredential.fullName?.familyName,
                            email: appleIDCredential.email,
                            provider: .apple,
                            authorizationCode: appleIDCredential.authorizationCode
                        )
                    )
                )
            }
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        guard (error as NSError).code != 1001 else {
            return
        }
        signInManager.resultAction(.failure(error))
    }
}

struct SignInWithAppleButton<CustomView: View>: View {
    @ObservedObject var signInManager: SignInWithAppleManager
    var customButtonView: CustomView
    
    init(
        result: @escaping (Result<SocialAuthData, Error>) -> (),
        customButtonView: CustomView
    ) {
        self.signInManager = .init(result: result)
        self.customButtonView = customButtonView
    }
    
    var body: some View {
        Button(action: signInManager.signIn) {
            customButtonView
        }
    }
}
