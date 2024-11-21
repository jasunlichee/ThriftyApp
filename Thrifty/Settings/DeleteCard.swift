//
//  DeleteCard.swift
//  Thrifty
//
//  Created by Jason Li on 11/21/24.
//

import SwiftUI

struct DeleteCard: View {
    var body: some View {
        HStack{
            Text("Delete Account")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(Theme.pred.mainColor)
        .cornerRadius(10)
    }
}

#Preview {
    DeleteCard()
}
