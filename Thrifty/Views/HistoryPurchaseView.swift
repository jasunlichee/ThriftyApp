//
//  HistoryPurchaseView.swift
//  Thrifty
//
//  Created by Jason Li on 9/13/24.
//

import SwiftUI

struct HistoryPurchaseView: View {
    let month: Month
    @State private var filteredCategory: String = "All"
    @State private var sortOption: SortOption = .dateDescending
    
    let categories = Purchase.categories
    
    var body: some View {
        NavigationStack {
            List{
                Section(header: Text("Purchases")){
                    if(month.purchases.isEmpty){
                        Label("No Purchases", systemImage: "cart.badge.questionmark")
                    }
                    
                    ForEach(month.purchases.indices.sorted(by: { sortingFunction(option: sortOption, p1: month.purchases[$0], p2: month.purchases[$1]) }), id: \.self) { index in
                        if(filteredCategory == "All" || filteredCategory == month.purchases[index].category){
                            PurchaseCard(purchase: month.purchases[index])
                                    .foregroundColor(.black)
                                    .listRowBackground(month.purchases[index].theme.mainColor)
                            .listRowInsets(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                            
                        }
                    }
                }
            }
            .navigationTitle("Purchase Details")
            .scrollContentBackground(.hidden)
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

#Preview {
    HistoryPurchaseView(month: Month.sampleData[0])
}
