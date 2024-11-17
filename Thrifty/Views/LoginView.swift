//
//  LoginView.swift
//  Thrifty
//
//  Created by Jason Li on 9/18/24.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import CryptoKit

struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {
    
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(authorizationButtonType: type, authorizationButtonStyle: style)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}


struct LoginView: View {
    @Binding var loggedIn: Bool
    
    @State private var isCreatingNewAccount = false
    @State private var nonce: String?
    @EnvironmentObject var googleVM: GoogleVM
    @EnvironmentObject var appleVM: AppleVM
    @EnvironmentObject var firestoreManager: FirebaseService
    @StateObject private var viewModel = SignInViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("LoginHeader")
                    .resizable()
                    .scaledToFit()
                
                VStack {
                    TextField("Email", text: $viewModel.email)
                    
                    Divider()
                    
                    SecureField("Password", text: $viewModel.password)
                    
                    Divider()
                    
                    Button(action: {
                        Task {
                            let success = await viewModel.signIn()
                            if(success){
                                firestoreManager.loggedIn = true
                                firestoreManager.checkAuthenticationStatus()
                            }
                        }
                    }){
                        Text("Sign In")
                    }
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: 250)
                    .background(Color.green)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                .frame(maxWidth: 250)
                .padding()
                
                
                
                Text("OR")
                    .font(.caption)
                
                
                Button(action: {
                    googleVM.signInWithGoogle()
                    if(googleVM.isGoogleLogin){
                        firestoreManager.checkAuthenticationStatus()
                    }
                    
                }){
                    HStack {
                        Image("Google")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                        
                        Text("Sign in with Google")
                            .font(.title3)
                    }
                    
                     
                }
                    .foregroundColor(.black)
                    .frame(height: 55)
                    .frame(maxWidth: 250)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                
                
                
                SignInWithAppleButton(.signIn) {request in
                    let nonce = appleVM.randomNonceString()
                    self.nonce = nonce
                    request.requestedScopes = [.email, .fullName]
                    request.nonce = appleVM.sha256(nonce)
                    
                } onCompletion: { result in
                    switch result {
                    case.success(let authorization):
                        loginWithFirebase(authorization)
                    case.failure(let error):
                        print(error)
                        
                    }
                }
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: 250)
                    .background(Color.black)
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)

                Text("Don't have an account?")
                    .font(.caption)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0))
                
                Button(action: {
                    isCreatingNewAccount = true
                }) {
                    Text("Sign Up")
                        .font(.caption)
                }
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .background(Color.white)
                
            }
            .padding()
            .alert(isPresented: $viewModel.showError) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        
        .padding(.horizontal)
        .sheet(isPresented: $isCreatingNewAccount) {
            SignUpView(isPresenting: $isCreatingNewAccount)
                .environmentObject(viewModel)
        }
    }
    
    func loginWithFirebase(_ authorization: ASAuthorization){
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
              guard let nonce else {
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
              let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
              Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error {
                  print(error.localizedDescription)
                  return
                }
                  firestoreManager.checkAuthenticationStatus()
                print("Logged in")
              }
            }
    }
    
}

#Preview {
    LoginView(loggedIn: .constant(false))
}
