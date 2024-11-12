//
//  SummaryView.swift
//  Thrifty
//
//  Created by Jason Li on 9/10/24.
//

import SwiftUI

struct SummaryView: View {
    @Binding var purchases: [Purchase]
    @Binding var month: Month
    @Binding var budget: Double
    
    
    var body: some View {
        HStack {
            VStack (alignment: .leading){
                Text("Summary")
                    .font(.headline)
                    .padding()
                Divider()
                HStack {
                    Text("Spent: $" + 
                         Purchase.toString(for: Month.moneySpent(for: month)))
                        .font(.caption)
                        .padding()
                    Spacer()
                    Text("Budget: $" + 
                         Purchase.toString(for: budget))
                        .font(.caption)
                        .padding()
                }
                
            }
            Image(systemName: "chevron.right")
                            .foregroundColor(.gray)

        }
        .frame(width: 330, height: 100)
        .padding()
        .background(Theme.seafoam.mainColor)
        .foregroundColor(Color.black)
        .cornerRadius(10)
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(purchases: .constant(Purchase.sampleData1), month: .constant(Month.sampleData[0]), budget: .constant(1000.0))
            .background(.yellow)
            .previewLayout(.fixed(width: 500, height: 150))
    }
}
