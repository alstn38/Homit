//
//  CategoryButtonsSection.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct CategoryButtonsSection: View {
    let onCategoryTapped: (EstateCategory) -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(EstateCategory.allCases, id: \.self) { category in
                CategoryButton(category: category) {
                    onCategoryTapped(category)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
    }
}
