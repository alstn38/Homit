//
//  TodayTopicsSection.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct TodayTopicsSection: View {
    let topics: [TopicEntity]
    let advertisements: [AdvertisementEntity]
    let onTopicTapped: (TopicEntity) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("오늘의 부동산 TOPIC")
                    .customTextStyle(font: PretendardFont.title1, color: .gray100)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            
            LazyVStack(spacing: 0) {
                ForEach(Array(topics.enumerated()), id: \.offset) { index, topic in
                    TopicCard(topic: topic) {
                        onTopicTapped(topic)
                    }
                    
                    if (index == 1 || index == 3) && advertisements.indices.contains(index / 2) {
                        AdvertisementCard(advertisement: advertisements[index / 2])
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                    }
                    
                    if index < topics.count - 1 {
                        Divider()
                            .padding(.horizontal, 24)
                    }
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
    }
}
