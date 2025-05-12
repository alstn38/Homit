//
//  LoginButton.swift
//  Homit
//
//  Created by 강민수 on 5/12/25.
//

import SwiftUI

struct LoginButton: View {
    
    let iconImage: Image
    let title: String
    let backgroundColor: Color
    let action: () -> Void
    
    init(
        iconImage: Image,
        title: String,
        backgroundColor: Color,
        action: @escaping () -> Void
    ) {
        self.iconImage = iconImage
        self.title = title
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                iconImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .customTextStyle(font: PretendardFont.body1, color: .black)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(backgroundColor)
            .foregroundColor(.black)
            .cornerRadius(12)
        }
    }
}
