//
//  Purchase.swift
//  Thrifty
//
//  Created by Jason Li on 9/9/24.
//

import Foundation

struct Purchase: Identifiable, Codable {
    let id: UUID
    var name: String
    var date: Date
    var cost: Double
    var category: String
    var icon: String
    var theme: Theme
    
    init(id: UUID = UUID(), name: String, date: Date, cost: Double, category: String) {
        self.id = id
        self.name = name
        self.date = date
        self.cost = cost
        self.category = category
        switch category {
        case "Travel":
            self.icon = "airplane"
            self.theme = Theme.pblue
        case "Dining":
            self.icon = "fork.knife"
            self.theme = Theme.pcream
        case "Transport":
            self.icon = "fuelpump"
            self.theme = Theme.pred
        case "Grocery":
            self.icon = "cart"
            self.theme = Theme.pgreen
        case "Leisure":
            self.icon = "bag"
            self.theme = Theme.pyellow
        case "Monthly":
            self.icon = "calendar"
            self.theme = Theme.plavender
        default:
            self.icon = ""
            self.theme = Theme.porange
        }
    }
}

/*
 Travel: Lavender
 Dining: Seafoam
 Gas: Poppy
 Grocery: Buttercup
 Entertainment: Yellow
 Subscriptions: Orange
 */

extension Purchase {
    static func theme(for category: String) -> Theme {
        switch category {
        case "Travel":
            return Theme.pblue
        case "Dining":
            return Theme.pcream
        case "Transport":
            return Theme.pred
        case "Grocery":
            return Theme.pgreen
        case "Leisure":
            return Theme.pyellow
        case "Monthly":
            return Theme.plavender
        default:
            return Theme.porange
        }
    }
    
    static func icon(for category: String) -> String {
        switch category {
        case "Travel":
            return "airplane"
        case "Dining":
            return "fork.knife"
        case "Transport":
            return "fuelpump"
        case "Grocery":
            return "cart"
        case "Leisure":
            return "bag"
        case "Monthly":
            return "calendar"
        default:
            return ""
        }
    }
    
    mutating func changeCategory(to newCategory: String){
        self.category = newCategory
        self.icon = Purchase.icon(for: newCategory)
        self.theme = Purchase.theme(for: newCategory)
    }
    
    static func toString(for amount: Double)-> String{
        return String(format: "%.2f", amount)
    }
    
    static var emptyPurchase: Purchase {
        Purchase(name: "", date: Date(), cost: 0.00, category: "")
    }
    
    static var categories: [String] {
        ["Travel", "Dining", "Transport", "Grocery", "Leisure", "Monthly"]
    }
    
    
}


extension Purchase {
    static let sampleData1: [Purchase] =
    [
        Purchase(name: "Netflix",
                 date: Month.convertDate(for: "09/16/2024"),
                 cost: 15.99,
                 category: "Monthly"),
        Purchase(name: "Costco",
                 date: Month.convertDate(for: "09/13/2024"),
                 cost: 95.24,
                 category: "Transport"),
        Purchase(name: "Chipotle",
                 date: Month.convertDate(for: "09/01/2024"),
                 cost: 11.98,
                 category: "Dining"),
        Purchase(name: "Pop Mart",
                 date: Month.convertDate(for: "09/12/2024"),
                 cost: 14.99,
                 category: "Leisure"),
        Purchase(name: "Burger Barn",
                 date: Month.convertDate(for: "09/11/2024"),
                 cost: 13.99,
                 category: "Dining"),
        Purchase(name: "iPhone",
                 date: Month.convertDate(for: "09/13/2024"),
                 cost: 799.99,
                 category: "Leisure"),
        
    ]
    
    static let sampleData2: [Purchase] =
    [
        Purchase(name: "Netflix",
                 date: Month.convertDate(for: "08/16/2024"),
                 cost: 15.99,
                 category: "Monthly"),
        Purchase(name: "Doordash",
                 date: Month.convertDate(for: "08/01/2024"),
                 cost: 24.99,
                 category: "Dining"),
        Purchase(name: "Costco",
                 date: Month.convertDate(for: "08/30/2024"),
                 cost: 84.25,
                 category: "Transport"),
    
    ]
    
    static let sampleData3: [Purchase] =
    [
        Purchase(name: "Netflix",
                 date: Month.convertDate(for: "07/16/2024"),
                 cost: 15.99,
                 category: "Monthly"),
        Purchase(name: "Legoland",
                 date: Month.convertDate(for: "07/03/2024"),
                 cost: 93.24,
                 category: "Leisure"),
        Purchase(name: "SD Zoo",
                 date: Month.convertDate(for: "07/04/2024"),
                 cost: 84.34,
                 category: "Leisure"),
        Purchase(name: "HMart",
                 date: Month.convertDate(for: "07/28/2024"),
                 cost: 34.68,
                 category: "Grocery"),
        Purchase(name: "MacBook Pro",
                 date: Month.convertDate(for: "06/11/2024"),
                 cost: 2399,
                 category: "Leisure"),
    ]
    
    static let sampleData4: [Purchase] =
    [
        Purchase(name: "Netflix",
                 date: Month.convertDate(for: "06/16/2024"),
                 cost: 15.99,
                 category: "Monthly"),
        Purchase(name: "Switch Game",
                 date: Month.convertDate(for: "06/03/2024"),
                 cost: 59.99,
                 category: "Leisure"),
        Purchase(name: "Chipotle",
                 date: Month.convertDate(for: "06/23/2024"),
                 cost: 11.98,
                 category: "Dining"),
        Purchase(name: "HMart",
                 date: Month.convertDate(for: "06/08/2024"),
                 cost: 34.68,
                 category: "Grocery"),
        Purchase(name: "McDonalds",
                 date: Month.convertDate(for: "06/19/2024"),
                 cost: 12.99,
                 category: "Dining"),
        Purchase(name: "Car Wash",
                 date: Month.convertDate(for: "06/11/2024"),
                 cost: 15.99,
                 category: "Transport"),
        
    
    
    ]
}

