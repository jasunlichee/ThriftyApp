//
//  SetupView.swift
//  Thrifty
//
//  Created by Jason Li on 11/12/24.
//

import SwiftUI
import Foundation

struct SetupView: View {
    @Binding var budget: Double;
    @Binding var billingCycle: Date
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var firestoreManager: FirebaseService
    
    var body: some View {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        VStack {
            Text("Account Setup")
                .font(.largeTitle)
            
            Text("Set Billing Cycle")
                .padding()
                
            Divider()
                .frame(maxWidth: 300)
            
            DatePicker(
                "Pick a date",
                selection: $billingCycle,
                in: startOfMonth...endOfMonth,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .labelsHidden()
            .frame(width: 300)
            
            BudgetCard(budget: $budget, tempbudget: $budget)
                .frame(maxWidth: 300)
                .padding()
                .shadow(radius: 2)
            
            Button(action: {
                firestoreManager.currentUser.cycleSet = true
                dismiss()
            }) {
                Text("Save")
            }
            .padding()

            
            
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Text("")
            }
        }
    }
}

struct Setup_Previews: PreviewProvider {
    
    static var previews: some View {
        let firePreview = FirebaseService()
        SetupView(budget: .constant(40.0), billingCycle: .constant(Date())).environmentObject(firePreview)
    }
}
