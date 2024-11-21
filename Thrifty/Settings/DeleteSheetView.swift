//
//  DeleteSheetView.swift
//  Thrifty
//
//  Created by Jason Li on 11/21/24.
//

import SwiftUI

struct DeleteSheetView: View {
    @Binding var isPresenting: Bool
    @Binding var isLoading: Bool
    var body: some View {
        NavigationStack{
            DeleteSheet(isPresenting: $isPresenting, isLoading: $isLoading)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction){
                        Button("Cancel"){
                            isPresenting = false
                        }
                    }
                }
        }
    }
}

#Preview {
    DeleteSheetView(isPresenting: .constant(true), isLoading: .constant(false))
}
