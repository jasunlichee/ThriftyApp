//
//  SignInVM.swift
//  Thrifty
//
//  Created by Jason Li on 10/30/24.
//

import Foundation

@MainActor
final class SignInViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    
    func signUp() async -> Bool{
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return false
        }
        do {
            let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
            print("Success")
            print(returnedUserData)
            return true
        } catch {
            print("Error: \(error)")
            return false
        }
    }
    
    func signIn() async -> Bool{
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return false
        }
        do {
            let returnedUserData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
            print("Success")
            print(returnedUserData)
            return true
        } catch {
            print("Error: \(error)")
            return false
        }
    }
    
}
