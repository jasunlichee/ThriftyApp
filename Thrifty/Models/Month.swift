//
//  Month.swift
//  Thrifty
//
//  Created by Jason Li on 9/9/24.
//

import Foundation
import SwiftUI


struct Month: Identifiable, Codable {
    let id: UUID
    var month: String
    var budget: Double
    var purchases: [Purchase]
    var startDate: Date
    var endDate: Date
    
    init(id: UUID = UUID(), budget: Double, purchases: [Purchase], startDate: Date, endDate: Date) {
        self.id = id
        self.month = Month.getMonthString(from: startDate)
        self.budget = budget
        self.purchases = purchases
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension Month {
    static func convertDate(for dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return Date()
        }
    }
    
    static func getyear(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
}

extension Month {
    static func moneySpent(for month: Month)-> Double {
        return month.purchases.reduce(0) { $0 + $1.cost }
    }
    
    static func backgroundColor(for month: Month)-> Color {
        if(moneySpent(for: month) > month.budget){
            return Theme.pred.mainColor
        } else {
            return Theme.pgreen.mainColor
        }
    }
    
    static func categorySpent(for category: String, in month: Month)-> Double {
        return month.purchases
                .filter { $0.category == category }
                .reduce(0) { $0 + $1.cost }
    }
    
    static func degrees(for month: Month) -> [String: Double] {
        var degreeMap: [String: Double] = [:]

        for category in Purchase.categories {
            degreeMap[category] = (categorySpent(for: category, in: month) * 360.0)/moneySpent(for: month)
        }

        return degreeMap
    }
    
    static func startingDegrees(for month: Month) -> [String: Double] {
        let degreeMap: [String: Double] = degrees(for: month)
        var startingMap: [String: Double] = [:]

        var starting: Double = 0.0
        for category in Purchase.categories {
            startingMap[category] = starting
            starting += degreeMap[category] ?? 0.0
        }

        return startingMap
    }
    
    static func getMonthString(from date: Date) -> String {
        let calendar = Calendar.current
        let monthNumber = calendar.component(.month, from: date)

        switch monthNumber {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            return "Unknown"
        }
    }
    
    
}

extension Month {
    static let sampleData: [Month] =
    [
        Month(budget: 1000.00,
              purchases: Purchase.sampleData1,
              startDate: convertDate(for: "09/01/2024"),
              endDate: convertDate(for: "09/30/2024")),
        Month(budget: 1000.00,
              purchases: Purchase.sampleData2,
              startDate: convertDate(for: "08/01/2024"),
              endDate: convertDate(for: "08/31/2024")),
        Month(budget: 1000.00,
              purchases: Purchase.sampleData3,
              startDate: convertDate(for: "07/01/2024"),
              endDate: convertDate(for: "07/31/2024")),
        Month(budget: 1000.00,
              purchases: Purchase.sampleData4,
              startDate: convertDate(for: "06/01/2024"),
              endDate: convertDate(for: "06/30/2024"))
    ]
}
