//
//  CustomTextStyle.swift
//  Homit
//
//  Created by 강민수 on 5/12/25.
//

import SwiftUI

struct CustomTextStyle: ViewModifier {
    
    let font: Font
    let color: Color

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }
}

extension View {
    func customTextStyle(font: Font, color: Color) -> some View {
        self.modifier(CustomTextStyle(font: font, color: color))
    }
}
