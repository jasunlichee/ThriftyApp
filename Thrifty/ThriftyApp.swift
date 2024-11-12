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
    
    
    func isSameMonthAndYear(as inputDate: Date) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        let currentComponents = calendar.dateComponents([.year, .month], from: today)
        let givenComponents = calendar.dateComponents([.year, .month], from: inputDate)

        return currentComponents.year == givenComponents.year && currentComponents.month == givenComponents.month
    }
    
    var body: some Scene {
        WindowGroup {
            if firestoreManager.isLoading {
                LoadingView()
            } else if firestoreManager.loggedIn || googleVM.isGoogleLogin{
                
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
                    
                    ProfileView(loggedIn: $loggedIn, billingCycle: $firestoreManager.currentUser.billingCycle)
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
                    selection = 1
                    firestoreManager.checkAuthenticationStatus()
                })
            } else {
                LoginView(loggedIn: $loggedIn)
                    .environmentObject(googleVM)
                    .environmentObject(appleVM)
                    .environmentObject(firestoreManager)

                
            }
        }
    }

}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


