//
//  MonthCard.swift
//  Thrifty
//
//  Created by Jason Li on 9/13/24.
//

import SwiftUI

struct MonthCard: View {
    @Binding var purchases: [Purchase]
    @Binding var month: Month
    
    private var backgroundColor: Color {
        Month.backgroundColor(for: month)
    }
    
    var body: some View {
        HStack {
            VStack (alignment: .leading){
                HStack {
                    Text("\(month.month)" + " " + "\(Month.getyear(for: month.startDate))")
                        .font(.headline)
                    .padding()
                    Spacer()
                    Text(formattedDate(month.startDate) + " - " + formattedDate(month.endDate))
                        .font(.caption)
                        .padding()
                }
                Divider()
                HStack {
                    Text("Spent: $" + 
                         Purchase.toString(for: Month.moneySpent(for: month)))
                        .font(.caption)
                        .padding()
                    Spacer()
                    Text("Budget: $" + Purchase.toString(for: month.budget))
                        .font(.caption)
                        .padding()
                }
                
            }
            Image(systemName: "chevron.right")
                            .foregroundColor(.black)

        }
        .frame(width: 330, height: 75)
        .padding()
        .background(backgroundColor)
        .foregroundColor(Color.black)
        .cornerRadius(10)
    }
                         
     func formattedDate(_ date: Date) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "MM/dd"
         return dateFormatter.string(from: date)
     }
}

struct MonthCard_Previews: PreviewProvider {
    static var previews: some View {
        MonthCard(purchases: .constant(Purchase.sampleData1), month: .constant(Month.sampleData[0]))
            .previewLayout(.fixed(width: 500, height: 150))
    }
}
