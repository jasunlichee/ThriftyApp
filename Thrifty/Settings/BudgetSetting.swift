//
//  BudgetSetting.swift
//  Thrifty
//
//  Created by Jason Li on 11/7/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct BudgetSetting: View {
    @Binding var budget: Double
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreManager: FirebaseService
    
    @State var tempbudget: Double = 0;
    
    var body: some View {
        VStack {
            Text("Monthly Budget")
                .font(.title)
                .padding()
            
            
            BudgetCard(budget: $budget, tempbudget: $tempbudget)
                .frame(maxWidth: 300)
                .padding()
                .shadow(radius: 4)
            
            Button(action: {
                budget = tempbudget
                dismiss()
            }) {
                Text("Save")
            }
            .padding()
            
        }
        .onAppear{
            tempbudget = budget;
        }
        .onDisappear{
            firestoreManager.currentUser.months[0].budget = budget
            firestoreManager.saveData()
        }
        
        
        

        
    }
}

struct BudgetSetting_Previews: PreviewProvider {
    
    static var previews: some View {
        let firePreview = FirebaseService()
        BudgetSetting(budget: .constant(20.0)).environmentObject(firePreview)
    }
}
