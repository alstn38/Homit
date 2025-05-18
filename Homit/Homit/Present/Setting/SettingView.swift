//
//  SettingView.swift
//  Homit
//
//  Created by 강민수 on 5/18/25.
//

import SwiftUI

import ComposableArchitecture

struct SettingView: View {
    
    @Perception.Bindable
    var store: StoreOf<SettingFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Text("프로필")
                    .customTextStyle(font: HaeparangFont.title1, color: .gray100)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray15)
        }
    }
}
