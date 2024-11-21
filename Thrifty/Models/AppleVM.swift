//
//  AppleVM.swift
//  Thrifty
//
//  Created by Jason Li on 9/20/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import AuthenticationServices
import CryptoKit

class AppleVM: NSObject, ObservableObject{
    var currentNonce: String?
    
    var completionHandler: ((Bool) -> Void)?

    func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    func startSignInWithAppleFlow(completion: @escaping (Bool) -> Void) {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        print("signInFlowDone")
        self.completionHandler = completion
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    
}

extension AppleVM: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        Task {
            do {
                try await reauthenticateWithApple(authorization)

            } catch {
                print("Reauthentication failed: \(error.localizedDescription)")
            }
        }
        self.completionHandler?(true)
        self.completionHandler = nil
    }
    
    func reauthenticateWithApple(_ authorization: ASAuthorization) async throws{
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let user = Auth.auth().currentUser else {
                throw NSError(domain: "FirebaseAuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found."])
            }
        
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                            rawNonce: nonce,
                                                            fullName: appleIDCredential.fullName)
            
            try await user.reauthenticate(with: credential)
            print("User reauthenticated")
        }
        
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        self.completionHandler?(true)
        self.completionHandler = nil
        print("Sign in with Apple errored: \(error)")
    }

}

extension AppleVM: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let windowScene = UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .compactMap { $0 as? UIWindowScene }
                    .first
                
        // Return the first window in that scene, or create a new window if none is available
        return windowScene?.windows.first { $0.isKeyWindow } ?? UIWindow()
    }
}
