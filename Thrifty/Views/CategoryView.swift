//
//  CategoryView.swift
//  Thrifty
//
//  Created by Jason Li on 9/9/24.
//

import SwiftUI

struct CategoryView: View {
    var category: String

    var body: some View {
        
        HStack{
            Image(systemName: Purchase.icon(for: category))
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            Text(category)
                .font(.system(size: 12, weight: .bold))
                .padding(.leading, 5)
        }
        .padding()
        .frame(width: 160, height: 60, alignment: .leading)
        .background(Purchase.theme(for: category).mainColor)
        .cornerRadius(10)

    }
}

#Preview {
    CategoryView(category: "Leisure")
}
