//
//  DetailView.swift
//  Thrifty
//
//  Created by Jason Li on 9/9/24.
//

import SwiftUI

struct DetailView: View {
    @Binding var purchases: [Purchase]
    @State private var editingPurchase = Purchase.emptyPurchase
    @State private var filteredCategory: String = "All"
    @State private var sortOption: SortOption = .dateDescending
    
    @EnvironmentObject var firestoreManager: FirebaseService
    
    let categories = Purchase.categories
    
    var body: some View {
        NavigationStack {
            List{
    
                Section(header: Text("Purchases")){
                    if(purchases.isEmpty){
                        Label("No Purchases", systemImage: "cart.badge.questionmark")
                    }
                    
                    let sortedPurchases = purchases.sorted(by: { sortingFunction(option: sortOption, p1: $0, p2: $1) })
                    
                    ForEach(sortedPurchases) { purchase in
                        if filteredCategory == "All" || filteredCategory == purchase.category {
                            NavigationLink(destination: PurchaseEditSheet(purchase: $purchases[purchases.firstIndex(where: { $0.id == purchase.id })!])) {
                                PurchaseCard(purchase: purchase)
                                    .foregroundColor(.black)
                            }
                            .listRowBackground(purchase.theme.mainColor)
                            .listRowInsets(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 15))
                        }
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            let purchaseToDelete = purchases.sorted(by: { sortingFunction(option: sortOption, p1: $0, p2: $1) })[index]
                            if let indexInArray = purchases.firstIndex(where: { $0.id == purchaseToDelete.id }) {
                                purchases.remove(at: indexInArray)
                            }
                        }
                        
                        firestoreManager.saveData()
                    })
                    
                }
            }
            .navigationTitle("Purchase Details")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: {
                            filteredCategory = "All"
                        }) {
                            Label("Show All Categories", systemImage: "tray.full")
                        }
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                filteredCategory = category
                            }) {
                                Label(category, systemImage: Purchase.icon(for: category))
                            }
                        }
                        
                    } label: {
                        Label("Filter", systemImage: "ellipsis.circle")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: {
                            sortOption = .dateDescending
                        }) {
                            Label("Date Descending", systemImage: "arrow.down.to.line.compact")
                        }
                        Button(action: {
                            sortOption = .dateAscending
                        }) {
                            Label("Date Ascending", systemImage: "arrow.up.to.line.compact")
                        }
                        Button(action: {
                            sortOption = .costDescending
                        }) {
                            Label("Cost Descending", systemImage: "arrow.down.to.line.compact")
                        }
                        Button(action: {
                            sortOption = .costAscending
                        }) {
                            Label("Cost Ascending", systemImage: "arrow.up.to.line.compact")
                        }
                    } label: {
                        Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                    }
                    
                }
                
            }
            
        }

    }
    
    enum SortOption {
        case dateAscending
        case dateDescending
        case costAscending
        case costDescending
    }
    
    func sortingFunction(option: SortOption, p1: Purchase, p2: Purchase) -> Bool {
        switch option {
        case .dateAscending:
            return p1.date < p2.date
        case .dateDescending:
            return p1.date > p2.date
        case .costAscending:
            return p1.cost < p2.cost
        case .costDescending:
            return p1.cost > p2.cost
        }
    }
}




struct DetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        let firePreview = FirebaseService()
        DetailView(purchases: .constant(Purchase.sampleData1)).environmentObject(firePreview)
    }
}
