//
//  PriceText.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct PriceText: View {
    let deposit: Int
    let monthlyRent: Int
    let font: Font
    var color: Color = .gray100
    
    var body: some View {
        Text("월세 \(formatPrice(deposit))/\(formatPrice(monthlyRent))")
            .customTextStyle(font: font, color: color)
    }
    
    private func formatPrice(_ price: Int) -> String {
        if price >= 10000 {
            let remainder = price % 10000
            if remainder == 0 {
                return "\(price / 10000)억"
            } else {
                return "\(price / 10000)억 \(remainder / 1000)천"
            }
        } else if price >= 1000 {
            let remainder = price % 1000
            if remainder == 0 {
                return "\(price / 1000)천"
            } else if remainder >= 100 {
                return "\(price / 1000),\(remainder / 100)00"
            } else {
                return "\(price / 1000),\(String(format: "%03d", remainder))"
            }
        } else {
            return "\(price)"
        }
    }
}
