//
//  FavoriteView.swift
//  Homit
//
//  Created by 강민수 on 5/18/25.
//

import SwiftUI

import ComposableArchitecture

struct FavoriteView: View {
    
    @Perception.Bindable
    var store: StoreOf<FavoriteFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Text("즐겨찾기")
                    .customTextStyle(font: HaeparangFont.title1, color: .gray100)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray15)
        }
    }
}
