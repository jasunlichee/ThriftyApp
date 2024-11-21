//
//  ProfileSetting.swift
//  Thrifty
//
//  Created by Jason Li on 11/6/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileSetting: View {
    @State private var isDeleting: Bool = false
    @EnvironmentObject var appleVM: AppleVM
    @Binding var isLoading: Bool
        
    @EnvironmentObject var firestoreManager: FirebaseService
    var body: some View {
        VStack {
            Text("\(firestoreManager.currentUser.email)")
                .padding()
            
            Button(role: .destructive) {
                if let user = Auth.auth().currentUser {
                    for profile in user.providerData {
                        switch profile.providerID {
                        case "google.com":
                            Task {
                                do {
                                    try await firestoreManager.reauthenticateWithGoogle()
                                    isLoading = true
                                    firestoreManager.loggedIn = false
                                    try await firestoreManager.deleteData()
                                    try await firestoreManager.deleteAccount()
                                } catch {
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                        case "apple.com":
                            appleVM.startSignInWithAppleFlow { success in
                                if success {
                                    isLoading = true
                                    firestoreManager.loggedIn = false
                                    Task{
                                        do {
                                            try await firestoreManager.deleteData()
                                            try await firestoreManager.deleteAccount()
                                        }
                                    }
                                } else {
                                    print("Authentication Failed failed.")
                                }
                            }
                        case "password":
                            isDeleting = true
                        default:
                            print("User signed in with an unknown provider")
                        }
                    }
                }

                
            } label: {
                Text("Delete Account")
            }
            .padding()
            .font(.title3)
            .foregroundColor(.white)
            .frame(width: 200, height: 40)
            .background(Theme.pred.mainColor)
            .cornerRadius(10)
        }
        .sheet(isPresented: $isDeleting) {
            DeleteSheetView(isPresenting: $isDeleting, isLoading: $isLoading)
                .environmentObject(firestoreManager)
        }
        
        
    }
}

struct ProfileSetting_Previews: PreviewProvider {
    static var previews: some View {
        let firePreview = FirebaseService()
        let applePreview = AppleVM()
        ProfileSetting(isLoading: .constant(false)).environmentObject(firePreview).environmentObject(applePreview)
    }
}
