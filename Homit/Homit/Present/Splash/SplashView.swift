//
//  SplashView.swift
//  Homit
//
//  Created by 강민수 on 5/18/25.
//

import SwiftUI

import ComposableArchitecture

struct SplashView: View {
    
    @Perception.Bindable
    var store: StoreOf<SplashFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Spacer()
                topView()
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Image("loginImage")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
    
    private func topView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("집을 찾는 따뜻한 여정")
            Text("Homit")
        }
        .customTextStyle(font: HaeparangFont.title1, color: .white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .shadow(radius: 3)
        .padding(.leading, 24)
        .padding(.top, 40)
    }
}
