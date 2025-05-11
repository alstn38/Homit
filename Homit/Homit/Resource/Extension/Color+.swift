//
//  Color+.swift
//  Homit
//
//  Created by 강민수 on 5/11/25.
//

import SwiftUI


extension Color {
    
    // MARK: - Brand Color
    static let deepCream = Color(hex: "#DAC8B1")
    static let brightCream = Color(hex: "#F1DCC1")
    
    static let deepCoast = Color(hex: "#298E9C")
    static let brightCoast = Color(hex: "#71C9D6")
    
    static let deepWood = Color(hex: "#402A32")
    static let brightWood = Color(hex: "#8C5543")
    
    // MARK: - Gray Scale Color
    static let gray0 = Color(hex: "#FFFFFF")
    static let gray15 = Color(hex: "#F9F9F9")
    static let gray30 = Color(hex: "#EAEAEA")
    static let gray45 = Color(hex: "#D8D6D7")
    static let gray60 = Color(hex: "#ABABAE")
    static let gray75 = Color(hex: "#6A6A6E")
    static let gray90 = Color(hex: "#434347")
    static let gray100 = Color(hex: "#0B0B0B")
}

extension Color {
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
