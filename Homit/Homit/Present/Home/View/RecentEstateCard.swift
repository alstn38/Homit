//
//  RecentEstateCard.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct RecentEstateCard: View {
    let estate: EstateEntity
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 12) {
                    EstateImageView(
                        imageURL: estate.thumbnailURL.first,
                        width: 80,
                        height: 80
                    )
                    .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            if estate.isRecommended {
                                CategoryBadge(
                                    text: "추천",
                                    backgroundColor: .brightCream,
                                    textColor: .deepCoast
                                )
                            }
                            
                            if estate.isSafeEstate {
                                CategoryBadge(
                                    text: "안전",
                                    backgroundColor: .brightWood,
                                    textColor: .white
                                )
                            }
                            
                            Text(estate.category)
                                .customTextStyle(font: PretendardFont.caption1, color: .gray60)
                            
                            Spacer()
                        }
                        
                        PriceText(
                            deposit: estate.deposit,
                            monthlyRent: estate.monthlyRent,
                            font: PretendardFont.body2
                        )
                        
                        AreaText(
                            area: estate.area,
                            font: PretendardFont.caption1,
                            color: .gray60
                        )
                    }
                    
                    Spacer()
                }
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(
                color: Color.black.opacity(0.08),
                radius: 4, x: 0, y: 2
            )
        }
        .frame(width: 280, height: 104)
    }
}
