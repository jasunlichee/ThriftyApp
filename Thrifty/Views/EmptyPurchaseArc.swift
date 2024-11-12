//
//  EmptyPurchaseArc.swift
//  Thrifty
//
//  Created by Jason Li on 11/12/24.
//

import SwiftUI

struct EmptyPurchaseArc: Shape {
    func path(in rect: CGRect) -> Path {
        let diameter = min(rect.size.width, rect.size.height) - 24.0
        let radius = diameter / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY)
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: Angle.degrees(0), endAngle: Angle.degrees(360), clockwise: false)
        }
    }
}

