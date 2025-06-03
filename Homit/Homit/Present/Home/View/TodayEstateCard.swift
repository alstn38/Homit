//
//  TodayEstateCard.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct TodayEstateCard: View {
    let estate: EstateEntity
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            GeometryReader { geometry in
                ZStack(alignment: .bottomLeading) {
                    EstateImageView(
                        imageURL: estate.thumbnailURL.first,
                        width: nil,
                        height: nil
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.6),
                            Color.black.opacity(0.3),
                            Color.clear,
                            Color.clear
                        ],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    
                    VStack(alignment: .leading, spacing: 12) {
                        LocationRow(
                            cityName: estate.locationEntity.cityName,
                            townName: estate.locationEntity.townName,
                            textColor: .white
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(estate.title)
                                .customTextStyle(font: HaeparangFont.title1, color: .white)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            
                            Text(estate.introduction)
                                .customTextStyle(font: PretendardFont.body2, color: .white)
                                .opacity(0.9)
                                .lineLimit(2)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 80)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .clipped()
    }
}
