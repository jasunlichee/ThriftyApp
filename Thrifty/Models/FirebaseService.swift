//
//  FirebaseService.swift
//  Thrifty
//
//  Created by Jason Li on 9/21/24.
//

import Foundation
import Firebase
import FirebaseFirestoreInternal
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import AuthenticationServices
import CryptoKit

@MainActor
class FirebaseService: ObservableObject {
    @Published var currentUser: ThriftyUser = ThriftyUser.sampleUser
    @Published var loggedIn: Bool = false
    @Published var isLoading: Bool = true
    //@Published var appleVM: AppleVM
        
    init() {
        checkAuthenticationStatus()
    }

    func checkAuthenticationStatus() {
        isLoading = true
        if let userID = Auth.auth().currentUser?.uid {
            loadUserData(userID: userID)
            print("Pulled data")
        } else {
            print("Not logged in")
            loggedIn = false
            isLoading = false
        }
    }

    func loadUserData(userID: String) {
        print("Loading")
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                do {
                    let userData = try document.data(as: ThriftyUser.self)
                    self.currentUser = userData
                    self.loggedIn = true
                    self.checkBillingMonth()
                    if(!self.isSameMonthAndYear(as: self.currentUser.months[0].startDate)){
                        self.addCurrentMonth(userID: self.currentUser.id)
                    }
                    NotificationsManager.shared.removeAllNotifications()
                    NotificationsManager.shared.scheduleMonthlyNotification(billingDate: self.currentUser.billingCycle)
                    self.isLoading = false;
                    print("User data loaded: \(userData)")
                } catch {
                    print("Error decoding user data: \(error)")
                    self.isLoading = false;
                }
            } else {
                print("User document does not exist, creating new user")
                let email = Auth.auth().currentUser?.email ?? "No email provided"
                self.createNewUserData(userID: userID, email: email, billingCycle: Date())
                self.loggedIn = true
                self.isLoading = false;
            }
        }
    }
    
    func reauthenticateWithEmailPassword(email: String, password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "FirebaseAuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found."])
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        

        try await user.reauthenticate(with: credential)
        print("Reauthentication successful with email/password.")
    }

    
    func reauthenticateWithGoogle() async throws{
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "FirebaseAuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found."])
        }
        
        let previousEmail = currentUser.email
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        
        let userAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: ApplicationUtility.rootViewController)
        
        let googleUser = userAuth.user
        
        guard let idToken = googleUser.idToken?.tokenString,
            let googleEmail = googleUser.profile?.email else {
            throw NSError(domain: "GoogleSignInError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve Google user information"])
        }
        
        if googleEmail != previousEmail {
            throw NSError(domain: "GoogleSignInError", code: -1, userInfo: [NSLocalizedDescriptionKey: "The account you selected does not match the currently logged-in user."])
        }
        
        let accessToken = googleUser.accessToken.tokenString
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        
        try await user.reauthenticate(with: credential)
    }
    
    func signInWithGoogle() async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let userAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: ApplicationUtility.rootViewController)
        
        let googleUser = userAuth.user
        
        guard let idToken = googleUser.idToken?.tokenString
            else {
            throw NSError(domain: "GoogleSignInError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve Google user information"])
        }
        
        let accessToken = googleUser.accessToken
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken.tokenString)
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    continuation.resume(throwing: error) // Resumes with the error if it occurs
                } else {
                    continuation.resume() // Resumes successfully when sign-in is successful
                }
            }
        }
        
    }
    
    func signOutWithGoogle() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            self.loggedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func deleteData() async throws {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.id)
        
        try await userRef.delete()
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        try await user.delete()
    }
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }

    func createNewUserData(userID: String, email: String, billingCycle: Date) {
        let calendar = Calendar.current
        let currentDate = Date()

        var startComponents = calendar.dateComponents([.year, .month], from: currentDate)
        startComponents.day = 1
        let startDate = calendar.date(from: startComponents)!
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let lastDay = range.count
        var endComponents = calendar.dateComponents([.year, .month], from: currentDate)
        endComponents.day = lastDay
        let endDate = calendar.date(from: endComponents)!
        let newMonth = Month(budget: 1000.0, purchases: [], startDate: startDate, endDate: endDate)
        
        self.currentUser = ThriftyUser(id: userID, email: email, billingCycle: startDate, months: [newMonth], budget: 1000.0)
        saveUserData(user: currentUser)
    }
    
    func saveData(){
        saveUserData(user: currentUser)
        NotificationsManager.shared.removeAllNotifications()
        NotificationsManager.shared.scheduleMonthlyNotification(billingDate: currentUser.billingCycle)
    }
    
    
    func saveUserData(user: ThriftyUser) {
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.id)
        
        do {
            try userRef.setData(from: user) { error in
                if let error = error {
                    print("Error saving user data: \(error.localizedDescription)")
                } else {
                    print("User data successfully saved.")
                }
            }
        } catch let error {
            print("Error encoding user data: \(error.localizedDescription)")
        }
    }
    
    
    func saveMonthToFirestore(userID: String, month: Month) {
        currentUser.months.insert(month, at: 0)
        saveData()
    }
    
    func checkBillingMonth(){
        print("Checking Billing Cycle")
        let userID = currentUser.id
        let oldCycle = currentUser.billingCycle
        let billingMonth = Calendar.current.component(.month, from: oldCycle)
        let currentMonth = Calendar.current.component(.month, from: Date())
        let billingYear = Calendar.current.component(.year, from: oldCycle)
        let currentYear = Calendar.current.component(.year, from: Date())
        
        if billingYear > currentYear || (billingYear == currentYear && billingMonth > currentMonth) {
            var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: oldCycle)
            dateComponents.year = billingYear
            dateComponents.month = billingMonth
            
            if let nextBillingCycle = Calendar.current.date(from: dateComponents) {
                print("Updating Month")
                print(oldCycle)
                updateBillingCycle(userID: userID, newBillingCycle: nextBillingCycle)
                saveData()
            }
        }
    }
    
    
    func updateBillingCycle(userID: String, newBillingCycle: Date) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)

        userRef.updateData([
            "billingCycle": newBillingCycle,
            "cycleSet": true
        ]) { error in
            if let error = error {
                print("Error updating billing cycle: \(error.localizedDescription)")
            } else {
                print("Billing cycle successfully updated.")
                self.currentUser.billingCycle = newBillingCycle
            }
        }
    }
    
    func addCurrentMonth(userID: String) {
        let calendar = Calendar.current
        let currentDate = Date()

        var startComponents = calendar.dateComponents([.year, .month], from: currentDate)
        startComponents.day = 1
        let startDate = calendar.date(from: startComponents)!
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let lastDay = range.count
        var endComponents = calendar.dateComponents([.year, .month], from: currentDate)
        endComponents.day = lastDay
        let endDate = calendar.date(from: endComponents)!
        let newMonth = Month(budget: 0.0, purchases: [], startDate: startDate, endDate: endDate)
        
        print(userID)
        print("Adding current month")
        saveMonthToFirestore(userID: userID, month: newMonth)
    }
    
    func updateBillingCycle()->Void {
        if(Date() > currentUser.billingCycle){
            if let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: currentUser.billingCycle) {
                currentUser.billingCycle = nextMonthDate
            }
        }
        saveData()
    }
    
    
    func isSameMonthAndYear(as inputDate: Date) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        let currentComponents = calendar.dateComponents([.year, .month], from: today)
        let givenComponents = calendar.dateComponents([.year, .month], from: inputDate)

        return currentComponents.year == givenComponents.year && currentComponents.month == givenComponents.month
    }
    
}
