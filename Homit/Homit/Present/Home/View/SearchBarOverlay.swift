//
//  SearchBarOverlay.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

struct SearchBarOverlay: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray60)
                .font(.system(size: 16))
            
            TextField("검색어를 입력해주세요.", text: $searchText)
                .customTextStyle(font: PretendardFont.body2, color: .gray75)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.95))
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 24)
    }
}
