//
//  ProgressBar.swift
//  Thrifty
//
//  Created by Jason Li on 9/10/24.
//

import SwiftUI

struct ProgressBar: ProgressViewStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
                .frame(height: 12.0)
                .padding(.horizontal)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(value: 0.4)
            .progressViewStyle(ProgressBar())
            .previewLayout(.sizeThatFits)
    }
}
