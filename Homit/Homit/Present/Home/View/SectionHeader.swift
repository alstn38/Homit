//
//  SectionHeader.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    let onViewAllTapped: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .customTextStyle(font: PretendardFont.title1, color: .gray100)
            
            Spacer()
            
            Button("View All") {
                onViewAllTapped()
            }
            .customTextStyle(font: PretendardFont.body3, color: .deepCoast)
        }
        .padding(.horizontal, 24)
    }
}
