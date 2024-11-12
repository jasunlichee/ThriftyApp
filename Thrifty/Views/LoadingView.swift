//
//  LoadingView.swift
//  Thrifty
//
//  Created by Jason Li on 11/4/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Image("LoginHeader")
                .resizable()
                .scaledToFit()
        }
        .frame(maxWidth: 250)
    }
}

#Preview {
    LoadingView()
}
