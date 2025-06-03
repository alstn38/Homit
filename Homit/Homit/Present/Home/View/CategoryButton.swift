//
//  CategoryButton.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct CategoryButton: View {
    let category: EstateCategory
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // 원형 배경 추가
                ZStack {
                    Circle()
                        .fill(Color.gray30)
                        .frame(width: 60, height: 60)
                    
                    Image(category.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                
                Text(category.displayName)
                    .customTextStyle(font: PretendardFont.caption1, color: .gray75)
            }
        }
    }
}
