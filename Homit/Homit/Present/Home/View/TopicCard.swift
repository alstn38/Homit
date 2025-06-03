//
//  TopicCard.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct TopicCard: View {
    let topic: TopicEntity
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(topic.title)
                        .customTextStyle(font: PretendardFont.body2, color: .gray100)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(topic.content)
                        .customTextStyle(font: PretendardFont.caption1, color: .gray60)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Text(topic.date)
                    .customTextStyle(font: PretendardFont.caption1, color: .gray60)
                    .frame(alignment: .trailing)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
