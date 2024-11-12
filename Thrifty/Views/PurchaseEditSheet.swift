//
//  PurchaseEditSheet.swift
//  Thrifty
//
//  Created by Jason Li on 9/10/24.
//

import SwiftUI

struct PurchaseEditSheet: View {
    @Binding var purchase: Purchase
    @State var editingPurchase: Purchase
    @Environment(\.dismiss) var dismiss
    
    init(purchase: Binding<Purchase>) {
        self._purchase = purchase
        _editingPurchase = State(initialValue: purchase.wrappedValue)
    }
    
    var body: some View {
        NavigationStack {
            PurchaseEditView(purchase: $editingPurchase)
                .toolbar {                    
                    ToolbarItem(placement: .confirmationAction){
                        Button("Done"){
                            purchase = editingPurchase
                            dismiss()
                        }
                        .disabled(editingPurchase.name == "" ||
                                  editingPurchase.cost <= 0 ||
                                  editingPurchase.theme == Theme.porange)
                    }
                }
        }
    }
}

#Preview {
    PurchaseEditSheet(purchase: .constant(Purchase.sampleData1[0]))
}
