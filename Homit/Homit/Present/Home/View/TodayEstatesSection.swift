//
//  TodayEstatesSection.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct TodayEstatesSection: View {
    let estates: [EstateEntity]
    @Binding var selectedIndex: Int
    @Binding var searchText: String
    let onEstateTapped: (EstateEntity) -> Void
    let onPageChanged: (Int) -> Void
    
    var body: some View {
        if !estates.isEmpty {
            ZStack(alignment: .top) {
                TabView(selection: $selectedIndex) {
                    ForEach(Array(estates.enumerated()), id: \.offset) { index, estate in
                        TodayEstateCard(estate: estate) {
                            onEstateTapped(estate)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 355)
                .onChange(of: selectedIndex) { newValue in
                    onPageChanged(newValue)
                }
                
                SearchBarOverlay(searchText: $searchText)
                    .padding(.top, 16)
            }
            .clipped()
        }
    }
}
