//
//  ObservableMonth.swift
//  Thrifty
//
//  Created by Jason Li on 11/8/24.
//

import Foundation

class ObservableMonth: ObservableObject {
    @Published var month: Month
    
    init(month: Month) {
        self.month = month
    }
}

