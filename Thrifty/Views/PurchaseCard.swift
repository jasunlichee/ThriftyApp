//
//  PurchaseCard.swift
//  Thrifty
//
//  Created by Jason Li on 9/9/24.
//

import SwiftUI

struct PurchaseCard: View {
    let purchase: Purchase
    var body: some View {
        HStack{
            Image(systemName: purchase.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            Text("\(purchase.name)")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            VStack {
                Text(formattedDate(purchase.date))
                    .frame(maxWidth: 80, alignment: .trailing)
                Spacer()
                Text("$" + Purchase.toString(for: purchase.cost))
                    .frame(maxWidth: 80, alignment: .trailing)
            }
            .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(purchase.theme.mainColor)
        .cornerRadius(10)
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}

struct PurchaseCard_Previews: PreviewProvider {
    static var purchase = Purchase.sampleData4[1]
    static var previews: some View {
        PurchaseCard(purchase: purchase)
    }
}
