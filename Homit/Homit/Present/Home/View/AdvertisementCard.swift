//
//  AdvertisementCard.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct AdvertisementCard: View {
    let advertisement: AdvertisementEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(advertisement.title)
                .customTextStyle(font: PretendardFont.body2, color: .gray100)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(advertisement.content)
                .customTextStyle(font: PretendardFont.caption1, color: .gray60)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(Color.brightCream.opacity(0.3))
        .cornerRadius(8)
    }
}
