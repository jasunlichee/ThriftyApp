//
//  RingView.swift
//  Thrifty
//
//  Created by Jason Li on 9/9/24.
//

import SwiftUI

struct RingView: View {
    @Binding var purchases: [Purchase]
    @Binding var month: Month
    
    @State private var selectedCategory: String? = nil
    @State private var isPressing: Bool = false
    @State private var fingerPosition: CGPoint = .zero
    
    
    private var degreeMap: [String: Double] {
        Month.degrees(for: month)
    }
    
    func isFingerWithinRing(geometry: GeometryProxy) -> Bool {
        let ringCenter = CGPoint(x: geometry.size.width / 2 - 17, y: geometry.size.height / 2)
        
        // Define the inner and outer radius based on your ring configuration
        let outerRadius: CGFloat = 175 // Example: outer radius of the ring
        let innerRadius: CGFloat = 125 // Example: inner radius of the ring

        // Calculate the distance from the ring center to the finger position
        let dx = fingerPosition.x - ringCenter.x
        let dy = fingerPosition.y - ringCenter.y
        let distance = sqrt(dx * dx + dy * dy)

        // Check if the distance falls within the ring's bounds
        return distance >= innerRadius && distance <= outerRadius
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(Purchase.categories.reversed(), id: \.self) { category in
                    PurchaseArc(category: category, month: month)
                        .rotation(Angle(degrees: -90))
                        .stroke(style: StrokeStyle(lineWidth: 40))
                        .foregroundColor(
                            selectedCategory == category ?
                            
                            Purchase.theme(for: category).mainColor.opacity(0.8)
                            :Purchase.theme(for: category).mainColor
                        
                        )
                        .gesture(
                            LongPressGesture(minimumDuration: 0.2)
                            .onEnded { _ in
                                isPressing = true
                                selectedCategory = category
                            }
                            .simultaneously(with: DragGesture(minimumDistance: 0)
                                .onChanged{value in
                                    fingerPosition = value.location
                                    if !isFingerWithinRing(geometry: geometry) {
                                        selectedCategory = nil
                                    }
                                }
                                .onEnded { _ in
                                    isPressing = false
                                    selectedCategory = nil
                                }
                            )
                        )
                }
                
                if isPressing, let category = selectedCategory {
                    VStack {
                        Text("\(category): $\(Purchase.toString(for: Month.categorySpent(for: category, in: month)))")
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .transition(.scale)
                        
                        Spacer()
                    }
                    .position(x: fingerPosition.x, y: fingerPosition.y + geometry.size.height / 2 - 50)
                    .animation(.easeInOut(duration: 0.3), value: isPressing)
                }

                
            }
            .padding(.horizontal)
            .frame(width: 350, height: geometry.size.height)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
    
}

#Preview {
    RingView(purchases: .constant(Purchase.sampleData1), month: .constant(Month.sampleData[0]))
}
