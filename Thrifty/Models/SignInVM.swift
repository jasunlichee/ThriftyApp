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
    @Published var errorMessage: String = ""
    @Published var showError = false
    
    
    func signUp() async -> Bool{
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "No email or password found."
            showError = true
            return false
        }
        do {
            let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
            print("Success")
            print(returnedUserData)
            return true
        } catch {
            errorMessage = "Invalid email or password."
            showError = true
            return false
        }
    }
    
    func signIn() async -> Bool{
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "No email or password found."
            showError = true
            return false
        }
        do {
            let returnedUserData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
            print("Success")
            print(returnedUserData)
            return true
        } catch {
            errorMessage = "Invalid email or password."
            showError = true
            return false
        }
    }
    
}
