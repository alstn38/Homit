//
//  AreaText.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct AreaText: View {
    let area: Double
    let font: Font
    let color: Color
    
    var body: some View {
        Text("전용면적 \(String(format: "%.1f", area))㎡")
            .customTextStyle(font: font, color: color)
    }
}
