//
//  HomeView.swift
//  Homit
//
//  Created by 강민수 on 5/18/25.
//

import SwiftUI

import ComposableArchitecture

struct HomeView: View {
    
    @Perception.Bindable
    var store: StoreOf<HomeFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Text("홈")
                    .customTextStyle(font: HaeparangFont.title1, color: .gray100)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray15)
        }
    }
}
