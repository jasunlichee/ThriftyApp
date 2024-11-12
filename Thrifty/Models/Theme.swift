//
//  Theme.swift
//  Thrifty
//
//  Created by Jason Li on 9/9/24.
//

import SwiftUI

enum Theme: String, CaseIterable, Identifiable, Codable {
    case pred
    case pblue
    case pgreen
    case porange
    case pcream
    case pyellow
    case plavender
    case seafoam
    
    var mainColor: Color {
        Color(rawValue)
    }
    var name: String {
        rawValue.capitalized
    }
    var id: String {
        name
    }
}

