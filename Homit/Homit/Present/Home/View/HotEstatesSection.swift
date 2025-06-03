//
//  HotEstatesSection.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct HotEstatesSection: View {
    let estates: [EstateEntity]
    let onEstateTapped: (EstateEntity) -> Void
    let onViewAllTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            SectionHeader(
                title: "HOT 매물",
                onViewAllTapped: onViewAllTapped
            )
            .padding(.top, 32)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(estates, id: \.id) { estate in
                        HotEstateCard(estate: estate) {
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
