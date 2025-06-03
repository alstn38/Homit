//
//  RecentEstatesSection.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct RecentEstatesSection: View {
    let estates: [EstateEntity]
    let onEstateTapped: (EstateEntity) -> Void
    let onViewAllTapped: () -> Void
    
    var body: some View {
        if !estates.isEmpty {
            VStack(spacing: 0) {
                SectionHeader(
                    title: "최근검색 매물",
                    onViewAllTapped: onViewAllTapped
                )
                .padding(.top, 32)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(estates, id: \.id) { estate in
                            RecentEstateCard(estate: estate) {
                                onEstateTapped(estate)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 16)
            }
        }
    }
}
