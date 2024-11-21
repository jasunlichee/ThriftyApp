//
//  DeleteSheet.swift
//  Thrifty
//
//  Created by Jason Li on 11/18/24.
//

import SwiftUI

struct DeleteSheet: View {
    @Binding var isPresenting: Bool
    @Binding var isLoading: Bool
    @EnvironmentObject var firestoreManager: FirebaseService
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        VStack {
            
            Form{
                Section(header: Text("Purchase Info")){
                    TextField("Email", text: $email)
                    TextField("Password", text: $password)
                }
                
                Button("Delete Account"){
                    Task {
                        do {
                            try await firestoreManager.reauthenticateWithEmailPassword(email: email, password: password)
                            
                            isLoading = true
                            firestoreManager.loggedIn = false
                            try await firestoreManager.deleteData()
                            try await firestoreManager.deleteAccount()
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
                .disabled(email == "" || password == "")
                .foregroundColor(Theme.pred.mainColor)
                
                
                
//
//            .font(.title3)
//            .foregroundColor(.white)
//            .frame(width: 330, height: 40)
//            .background(Theme.pred.mainColor)
//            .cornerRadius(10)
//        }
//        .listRowBackground(Theme.pred.mainColor)
                
                
            }
            
            
        }
    }
}

struct DeleteSheet_Previews: PreviewProvider {
    
    static var previews: some View {
        let firePreview = FirebaseService()
        DeleteSheet(isPresenting: .constant(true), isLoading: .constant(false)).environmentObject(firePreview)
    }
}
