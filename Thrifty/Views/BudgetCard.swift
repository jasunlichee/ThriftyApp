//
//  BudgetCard.swift
//  Thrifty
//
//  Created by Jason Li on 11/7/24.
//

import SwiftUI

struct BudgetCard: View {
    @Binding var budget: Double
    @Binding var tempbudget: Double
    var body: some View {
        VStack {
            HStack{
                Text("Budget")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("$\(budget, specifier: "%.2f")")
                    .padding()
                
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 60)
            
            
            HStack {
                Button(action: {
                    if tempbudget >= 50 { tempbudget -= 50.0 }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .frame(width: 130, height: 40)
                        .padding()
                        
                    TextField("Amount", value: $tempbudget, format: .currency(code: "USD"))
                        .keyboardType(.numberPad)
                        .background(.white)
                        .padding()
                        .frame(maxWidth: 200)
                        .multilineTextAlignment(.center)
                }
                Button(action: {
                    tempbudget += 50.0
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.gray)
                        .font(.headline)
                    
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 60)
            .cornerRadius(10)
            
        }
        .background(.white)
        .cornerRadius(10)
    }
}

#Preview {
    BudgetCard(budget: .constant(200.0), tempbudget: .constant(100.0))
}
