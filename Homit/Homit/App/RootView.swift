//
//  RootView.swift
//  Homit
//
//  Created by 강민수 on 5/19/25.
//

import SwiftUI

import ComposableArchitecture

struct RootView: View {
    
    @Perception.Bindable
    var store: StoreOf<AppFeature>
    
    var body: some View {
        WithPerceptionTracking {
            if let tabBarStore = store.scope(state: \.tabBar, action: \.tabBar) {
                TabBarView(store: tabBarStore)
            } else if let loginStore = store.scope(state: \.login, action: \.login) {
                LoginView(store: loginStore)
            } else {
                SplashView(store: store.scope(state: \.splash, action: \.splash))
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
