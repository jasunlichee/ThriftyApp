//
//  NotificationsCard.swift
//  Thrifty
//
//  Created by Jason Li on 11/16/24.
//

import SwiftUI

struct NotificationsCard: View {
    var body: some View {
        HStack{
            Image(systemName: "gear.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            Text("Open Settings")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(Theme.seafoam.mainColor)
        .cornerRadius(10)
    }
}

#Preview {
    NotificationsCard()
}
