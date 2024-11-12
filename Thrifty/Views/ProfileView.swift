//
//  ProfileView.swift
//  Thrifty
//
//  Created by Jason Li on 9/12/24.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth

struct ProfileView: View {
    @Binding var loggedIn: Bool
    @Binding var billingCycle: Date
    @Binding var isLoading: Bool
    @EnvironmentObject var googleVM: GoogleVM
    @EnvironmentObject var appleVM: AppleVM
    @StateObject private var vm = ProfileVM()
    @EnvironmentObject var firestoreManager: FirebaseService
    
    var bg: Color = Theme.seafoam.mainColor
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Profile Settings")
                    .font(.largeTitle)
                    .padding(.bottom, 30)
                
                List {
                    Section(header: Text("Account Settings")){
                        NavigationLink(destination: ProfileSetting(vm: vm)) {
                            SettingsCard(name: "Profile", bg: bg, icon: "person.circle")
                        }
                        .foregroundColor(.black)
                        .listRowBackground(bg)
                        .listRowInsets(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 15))
                        
                        NavigationLink(destination: CycleSetting(billingCycle: $firestoreManager.currentUser.billingCycle)) {
                            SettingsCard(name: "Billing Cycle", bg: bg, icon: "calendar.badge.clock")
                        }
                        .foregroundColor(.black)
                        .listRowBackground(bg)
                        .listRowInsets(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 15))
                        
                        NavigationLink(destination: BudgetSetting(budget: $firestoreManager.currentUser.budget)) {
                            SettingsCard(name: "Budget", bg: bg, icon: "creditcard.and.123")
                        }
                        .foregroundColor(.black)
                        .listRowBackground(bg)
                        .listRowInsets(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 15))
                    }
                    
                    Section(header: Text("App Settings")){
                        NavigationLink(destination: TestView()) {
                            SettingsCard(name: "Notifications", bg: bg, icon: "bell.badge")
                        }
                        .foregroundColor(.black)
                        .listRowBackground(bg)
                        .listRowInsets(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 15))
                        
                        NavigationLink(destination: TestView()) {
                            SettingsCard(name: "Night Mode", bg: bg, icon: "moon.stars")
                        }
                        .foregroundColor(.black)
                        .listRowBackground(bg)
                        .listRowInsets(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 15))
                    }
                        
                    Section(){
                        Button(action: {
                            googleVM.signOut()
                            Task {
                                do {
                                    try vm.logOut()
                                    
                                } catch {
                                    print(error)
                                }
                            }
                            isLoading = true
                            firestoreManager.loggedIn = false
                        }){
                            Text("Sign Out of Your Account")
                        }
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 330, height: 40)
                        .background(Theme.pred.mainColor)
                        .cornerRadius(10)
                    }
                    .listRowBackground(Theme.pred.mainColor)
                }
                .navigationTitle("")
                .scrollContentBackground(.hidden)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing){
                        Text("")
                    }
                }
                
                
            }
            .onAppear{
                try? vm.loadCurrentUser()
            }
        }
        
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let gPreview = GoogleVM()
        let firePreview = FirebaseService()
        ProfileView(loggedIn: .constant(false), billingCycle: .constant(Date()), isLoading:.constant(true)).environmentObject(gPreview).environmentObject(firePreview)
    }
}
