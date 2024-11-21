//
//  NewPurchaseView.swift
//  Thrifty
//
//  Created by Jason Li on 9/9/24.
//

import SwiftUI


struct PurchaseEditView: View {
    @Binding var purchase: Purchase
    @Binding var amount: Double?
    
    let categories = Purchase.categories
    
    let gridLayout = [
        GridItem(.flexible(), spacing: 30),
        GridItem(.flexible(), spacing: 30)
    ]

    var body: some View {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        Form {
            Section(header: Text("Purchase Info")){
                TextField("Item Purchased", text: $purchase.name)
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                DatePicker(
                        "Start Date",
                        selection: $purchase.date,
                        in: startOfMonth...endOfMonth,
                        displayedComponents: [.date]
                    )

                }
            Section(header: Text("Category")) {
                LazyVGrid(columns: gridLayout, spacing: 20) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            purchase.changeCategory(to: category)
                        }) {
                            CategoryView(category: category)
                                .background(
                                    purchase.category == category ? Color.blue.opacity(0.4) : Color.clear
                                )
                                .cornerRadius(10)
                                .foregroundColor(.black)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .shadow(color: purchase.category == category ? Color.blue.opacity(0.7) : Color.clear, radius: 10, x: 0, y: 4)
                    }
                }

            }
            
        }
    }
}

#Preview {
    
    PurchaseEditView(purchase: .constant(Purchase.emptyPurchase), amount: .constant(nil))
}
