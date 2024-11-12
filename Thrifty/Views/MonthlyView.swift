//
//  MonthlyView.swift
//  Thrifty
//
//  Created by Jason Li on 9/9/24.
//

import SwiftUI
import FirebaseAuth

struct MonthlyView: View {
    @Binding var month: Month
    @State private var isAddingNewPurchase = false
    @EnvironmentObject var firestoreManager: FirebaseService
    
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var vm = ProfileVM()

    var body: some View {
        NavigationStack {
            VStack{
                Text("\(month.month)")
                    .font(.largeTitle)
                MonthlyHeaderView(month: $month, budget: $firestoreManager.currentUser.budget, purchases: $month.purchases)
                    .padding()
                Text("Expense Breakdown")
                
                RingView(purchases: $month.purchases, month: $month)
                    .frame(minWidth: 350, maxWidth: 350)
//                    .background{
//                        Image("Icon")
//                                .resizable()
//                                .frame(width: 100, height: 100)
//                    }
                NavigationLink(destination: DetailView(purchases: $month.purchases)) {
                    SummaryView(purchases: $month.purchases, month: $month, budget: $firestoreManager.currentUser.budget)
                    
                }
                .navigationTitle("")
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingNewPurchase = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isAddingNewPurchase) {
            NewPurchaseSheet(purchases: $month.purchases, isPresenting: $isAddingNewPurchase)
                .environmentObject(firestoreManager)
        }
        
    }
    
}

//DetailView(purchases: $purchases)

struct MonthlyView_Previews: PreviewProvider {
    
    static var previews: some View {
        let firePreview = FirebaseService()
        MonthlyView(month: .constant(Month.sampleData[0])).environmentObject(firePreview)
    }
}
