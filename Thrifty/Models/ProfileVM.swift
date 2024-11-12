//
//  ProfileVM.swift
//  Thrifty
//
//  Created by Jason Li on 10/25/24.
//

import Foundation

@MainActor
final class ProfileVM: ObservableObject {
    @Published private(set) var user: AuthDataResultModel? = nil
    
    func loadCurrentUser() throws {
        self.user = try AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
}
