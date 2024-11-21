//
//  NewPurchaseSheet.swift
//  Thrifty
//
//  Created by Jason Li on 9/9/24.
//

import SwiftUI
import FirebaseAuth

struct NewPurchaseSheet: View {
    @State private var newPurchase = Purchase.emptyPurchase
    @Binding var purchases: [Purchase]
    @Binding var isPresenting: Bool
    @State var amount: Double?
    
    @EnvironmentObject var firestoreManager: FirebaseService
    
    var body: some View {
        NavigationStack{
            PurchaseEditView(purchase: $newPurchase, amount: $amount)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction){
                        Button("Cancel"){
                            isPresenting = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction){
                        Button("Add"){
                            newPurchase.cost = amount ?? 0.0
                            purchases.append(newPurchase)
                            firestoreManager.saveData()
                            isPresenting = false
                            
                        }
                        .disabled(newPurchase.name == "" ||
                                  amount == nil ||
                                  newPurchase.theme == Theme.porange)
                    }
                }
        }
    }
}

struct NewPurchaseSheetPreview: PreviewProvider {
    
    static var previews: some View {
        let firePreview = FirebaseService()
        NewPurchaseSheet(purchases: .constant(Purchase.sampleData1), isPresenting: .constant(true)).environmentObject(firePreview)
    }
}
