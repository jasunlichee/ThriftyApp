//
//  HistoryView.swift
//  Thrifty
//
//  Created by Jason Li on 9/12/24.
//

import SwiftUI

struct HistoryView: View {
    @Binding var months: [Month]
    @State private var sortOption: SortOption = .dateDescending
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Text("Purchase History")
                    .font(.largeTitle)
                List{
                    Section(header: Text("Months")){
                        if(months.count == 1){
                            Label("No History", systemImage: "calendar.badge.exclamationmark")
                        }
                        
                        ForEach(months.indices.dropFirst().sorted(by: { sortingFunction(option: sortOption, m1: months[$0], m2: months[$1]) }), id: \.self) { index in
                            NavigationLink(destination: HistoryPurchaseView(month: months[index])) {
                                MonthCard(purchases: $months[index].purchases, month: $months[index])
                            }
                            .listRowBackground(Month.backgroundColor(for: months[index]))
                            .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 0))
                        }
                    }
                }
                .navigationTitle("")
                .scrollContentBackground(.hidden)
                .toolbar{
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
                        } label: {
                            Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                        }
                        
                    }
                }
            }
            
        }
        
        
    }
    
    enum SortOption {
        case dateAscending
        case dateDescending
    }
    
    func sortingFunction(option: SortOption, m1: Month, m2: Month) -> Bool {
        switch option {
        case .dateAscending:
            return m1.startDate < m2.startDate
        case .dateDescending:
            return m1.startDate > m2.startDate
        }
    }
}

#Preview {
    HistoryView(months: .constant(Month.sampleData))
}
