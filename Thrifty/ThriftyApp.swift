//
//  ThriftyApp.swift
//  Thrifty
//
//  Created by Jason Li on 9/9/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn



@main
struct ThriftyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var googleVM = GoogleVM()
    @StateObject private var appleVM = AppleVM()
    @StateObject var firestoreManager = FirebaseService()
    @StateObject private var vm = ProfileVM()
    
    @State private var loggedIn = false
    @State private var billingCycle: Date = Date()
    @State private var cycleSet: Bool = false

    @State private var selection: Int = 1
    @State private var budget: Double = 0.0
    
    @State private var isLoading = true
    
    var body: some Scene {
        WindowGroup {
            if firestoreManager.isLoading {
                LoadingView()
            } else if firestoreManager.loggedIn{
                
                //$firestoreManager.currentUser.months
                
                TabView (selection: $selection){
                    MonthlyView(month: $firestoreManager.currentUser.months[0])
                    .environmentObject(firestoreManager)
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(1)
                    .toolbar(.visible, for: .tabBar)
                    .onAppear() {
                        self.selection = 1
                    }
                    
                    HistoryView(months: $firestoreManager.currentUser.months)
                    .tabItem {
                        Image(systemName: "clock")
                    }
                    .tag(2)
                    .toolbar(.visible, for: .tabBar)
                    .onAppear() {
                        self.selection = 2
                    }
                    
                    ProfileView(loggedIn: $loggedIn, billingCycle: $firestoreManager.currentUser.billingCycle, isLoading: $isLoading)
                    .environmentObject(firestoreManager)
                    .environmentObject(googleVM)
                    .environmentObject(appleVM)
                    .tabItem {
                        Image(systemName: "person")
                    }
                    .tag(3)
                    .toolbar(.visible, for: .tabBar)
                    .onAppear() {
                        self.selection = 3
                    }
                }
                .onAppear(perform: {
                    firestoreManager.checkBillingMonth()
                    selection = 1
                })
            } else {
                LoginView(loggedIn: $loggedIn)
                    .environmentObject(googleVM)
                    .environmentObject(appleVM)
                    .environmentObject(firestoreManager)
                    .onDisappear{
                        //firestoreManager.checkAuthenticationStatus()
                        print("Init")
                    }

                
            }
        }
    }

}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      NotificationsManager.shared.requestPermission()
    return true
  }
}


