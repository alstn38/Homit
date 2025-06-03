//
//  HotEstateCard.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct HotEstateCard: View {
    let estate: EstateEntity
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .bottomLeading) {
                        EstateImageView(
                            imageURL: estate.thumbnailURL.first,
                            width: 280,
                            height: 160
                        )
                        
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.7),
                                Color.clear
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(estate.title + ", 여기가 전국")
                                .customTextStyle(font: PretendardFont.body1, color: .white)
                                .lineLimit(1)
                            
                            PriceText(
                                deposit: estate.deposit,
                                monthlyRent: estate.monthlyRent,
                                font: PretendardFont.title1,
                                color: .white
                            )
                            
                            AreaText(
                                area: estate.area,
                                font: PretendardFont.caption1,
                                color: .white
                            )
                        }
                        .padding(16)
                    }
                }
                .background(Color.white)
                
                Image("fire")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.gray0)
                    .padding(12)
            }
        }
        .frame(width: 280)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        .clipped()
    }
}
