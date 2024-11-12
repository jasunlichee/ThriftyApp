//
//  PurchaseArc.swift
//  Thrifty
//
//  Created by Jason Li on 9/13/24.
//

import SwiftUI

struct PurchaseArc: Shape {
    let category: String
    let month: Month
    
    private var degreeMap: [String:Double] {
        Month.degrees(for: month)
    }
    
    private var startingMap: [String: Double] {
        Month.startingDegrees(for: month)
    }

    private var startAngle: Angle {
        return Angle(degrees: startingMap[category] ?? 0.0)
    }
    private var endAngle: Angle {
        return startAngle + Angle(degrees: degreeMap[category] ?? 0.0 - 1.0)
    }


    func path(in rect: CGRect) -> Path {
        let diameter = min(rect.size.width, rect.size.height) - 24.0
        let radius = diameter / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY)
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
    }
}

