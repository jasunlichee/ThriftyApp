//
//  CycleSetting.swift
//  Thrifty
//
//  Created by Jason Li on 11/6/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct CycleSetting: View {
    @Binding var billingCycle: Date
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var firestoreManager: FirebaseService
    
    
    var body: some View {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        VStack {
            Text("Billing Cycle")
                .font(.title)
                .padding()
            
            Divider()
                .frame(width: 300)
            
            DatePicker(
                "Pick a date",
                selection: $billingCycle,
                in: startOfMonth...endOfMonth,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .labelsHidden()
            .frame(width: 300)
            .padding()
            
            Divider()
                .frame(width: 300)
            
            Button(action: {
                dismiss()
            }) {
                Text("Done")
            }
            .padding()
            
            
        }
        .onAppear{
            billingCycle = firestoreManager.currentUser.billingCycle
        }
        .onDisappear{
            firestoreManager.currentUser.billingCycle = billingCycle
            firestoreManager.saveData()
        }
    }
}

struct CycleSetting_Previews: PreviewProvider {
    
    static var previews: some View {
        let firePreview = FirebaseService()
        CycleSetting(billingCycle: .constant(Date())).environmentObject(firePreview)
    }
}
