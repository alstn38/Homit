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
            switch store.currentScreen {
            case .splash:
                SplashView(store: store.scope(state: \.splash, action: \.splash))
            case .login:
                if let loginStore = store.scope(state: \.login, action: \.login) {
                    LoginView(store: loginStore)
                }
            case .tabBar:
                TabBarView(store: store.scope(state: \.tabBar, action: \.tabBar))
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
