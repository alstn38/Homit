//
//  LocationRow.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct LocationRow: View {
    let cityName: String
    let townName: String
    let textColor: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "location")
                .foregroundColor(textColor)
                .font(.system(size: 12))
            
            Text("\(cityName) \(townName)")
                .customTextStyle(font: PretendardFont.caption1, color: textColor)
        }
    }
}
