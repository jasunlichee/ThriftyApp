//
//  NewPurchaseView.swift
//  Thrifty
//
//  Created by Jason Li on 9/9/24.
//

import SwiftUI

struct PurchaseEditView: View {
    @Binding var purchase: Purchase
    
    let categories = Purchase.categories
    
    let gridLayout = [
        GridItem(.flexible(), spacing: 30),
        GridItem(.flexible(), spacing: 30)
    ]

    var body: some View {
        Form {
            Section(header: Text("Purchase Info")){
                TextField("Item Purchased", text: $purchase.name)
                TextField("Amount", value: $purchase.cost, format: .currency(code: "USD"))
                    .keyboardType(.numberPad)
                DatePicker(
                        "Start Date",
                        selection: $purchase.date,
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
                    }
                }

            }
            
        }

    }
}

#Preview {
    
    PurchaseEditView(purchase: .constant(Purchase.emptyPurchase))
}