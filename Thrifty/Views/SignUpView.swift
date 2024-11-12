//
//  SignUpView.swift
//  Thrifty
//
//  Created by Jason Li on 9/20/24.
//

import SwiftUI

struct SignUpView: View {
    @Binding var isPresenting: Bool
    @EnvironmentObject var viewModel: SignInViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                Image("LoginHeader")
                    .resizable()
                    .scaledToFit()
                
                TextField("Email", text: $viewModel.email)
                
                Divider()
                
                SecureField("Password", text: $viewModel.password)
                
                Divider()
                
                Button(action: {
                    Task {
                        let success = await viewModel.signUp()
                        if success {
                            isPresenting = false
                        }
                    }
                }){
                    Text("Sign Up")
                }
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: 250)
                .background(Color.green)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                
                
                
            }
            .frame(maxWidth: 250)
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel"){
                        isPresenting = false
                    }
                }
            }
        }
        
    }
}

#Preview {
    SignUpView(isPresenting: .constant(true))
        .environmentObject(SignInViewModel())
}
