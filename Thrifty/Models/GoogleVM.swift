//
//  GoogleVM.swift
//  Thrifty
//
//  Created by Jason Li on 9/18/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class GoogleVM: ObservableObject {
    @Published var isGoogleLogin = false
    
    init() {
        self.isGoogleLogin = Auth.auth().currentUser != nil
    }
    
    func signInWithGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: ApplicationUtility.rootViewController) { user, error in
            if let error = error {
                print("Google Sign-In Error: \(error.localizedDescription)")
                print("Full Error Details: \(error)")
                return
                
            }
            
            guard
                let user = user?.user,
                let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) {res, error in
                if let error = error {
                    print("Google Sign-In Error: \(error.localizedDescription)")
                    print("Full Error Details: \(error)")
                    return
                }
                
                self.isGoogleLogin = true
                
                
            }
            
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            self.isGoogleLogin = false
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
}

