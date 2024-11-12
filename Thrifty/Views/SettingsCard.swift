//
//  SettingsCard.swift
//  Thrifty
//
//  Created by Jason Li on 11/6/24.
//

import SwiftUI

struct SettingsCard: View {
    var name: String
    var bg: Color
    var icon: String
    var body: some View {
        HStack{
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            Text("\(name)")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(bg)
        .cornerRadius(10)
    }
}

#Preview {
    SettingsCard(name: "Account", bg: Theme.seafoam.mainColor, icon: "person.circle")
}
