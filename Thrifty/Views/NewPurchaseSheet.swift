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
    @EnvironmentObject var firestoreManager: FirebaseService
    
    var body: some View {
        NavigationStack{
            PurchaseEditView(purchase: $newPurchase)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction){
                        Button("Cancel"){
                            isPresenting = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction){
                        Button("Add"){
                            purchases.append(newPurchase)
                            firestoreManager.saveData()
                            isPresenting = false
                            
                        }
                        .disabled(newPurchase.name == "" ||
                                  newPurchase.cost <= 0 ||
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
