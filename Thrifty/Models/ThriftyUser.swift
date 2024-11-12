//
//  User.swift
//  Thrifty
//
//  Created by Jason Li on 9/24/24.
//

import Foundation
import SwiftUI


class ThriftyUser: ObservableObject, Identifiable, Codable {
    let id: String
    var email: String
    var billingCycle: Date
    var cycleSet: Bool
    var months: [Month]
    var budget: Double

    init(id: String, email: String, billingCycle: Date, months: [Month] = [], budget: Double) {
        self.id = id
        self.email = email
        self.billingCycle = billingCycle
        self.cycleSet = false
        self.months = months
        self.budget = budget
    }
}

extension ThriftyUser {
    static let sampleUser: ThriftyUser = ThriftyUser(id: "0", email: "sample@gmail.com", billingCycle: Date(), months: [], budget: 1000.00)
}
