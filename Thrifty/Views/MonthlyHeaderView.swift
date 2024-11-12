//
//  MonthlyHeaderView.swift
//  Thrifty
//
//  Created by Jason Li on 9/10/24.
//

import SwiftUI

struct MonthlyHeaderView: View {
    @Binding var month: Month
    @Binding var budget: Double
    @Binding var purchases: [Purchase]
    
    private var moneySpent: Double {
        purchases.reduce(0) { $0 + $1.cost }
    }
    
    private var progress: Double {
        guard budget > 0 else {return 1}
        guard moneySpent < budget else {return 1}
        return moneySpent/budget
    }
    
    var body: some View {
        
        if(progress >= 1){
            ProgressView(value: progress)
                .progressViewStyle(ProgressBar())
                .tint(.red)
        } else {
            ProgressView(value: progress)
                .progressViewStyle(ProgressBar())
                .tint(.blue)
        }
    }
}

#Preview {
    MonthlyHeaderView(month: .constant(Month.sampleData[0]),
                      budget: .constant(1000.0),
                      purchases: .constant(Purchase.sampleData1))
        .previewLayout(.sizeThatFits)
}
