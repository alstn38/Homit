//
//  CategoryBadge.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct CategoryBadge: View {
    let text: String
    let backgroundColor: Color
    let textColor: Color
    
    var body: some View {
        Text(text)
            .customTextStyle(font: PretendardFont.caption1, color: textColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .cornerRadius(4)
    }
}
