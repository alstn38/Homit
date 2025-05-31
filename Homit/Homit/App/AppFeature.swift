//
//  AppFeature.swift
//  Homit
//
//  Created by 강민수 on 5/19/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct AppFeature {
    
    @Dependency(\.authStateManager) var authStateManager
    
    @ObservableState
    struct State {
        var splash = SplashFeature.State()
        var login: LoginFeature.State?
        var tabBar: TabBarFeature.State?
    }
    
    enum Action {
        case splash(SplashFeature.Action)
        case login(LoginFeature.Action)
        case tabBar(TabBarFeature.Action)
        case onAppear
        case authStateChanged(AuthState)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    for await authState in authStateManager.$authState.values {
                        await send(.authStateChanged(authState))
                    }
                }
                
            case .splash(.proceedToNextScreen):
                switch authStateManager.authState {
                case .authenticated:
                    state.tabBar = TabBarFeature.State()
                    state.login = nil
                    authStateManager.updateAuthState(.authenticated)
                    
                case .unauthenticated:
                    state.login = LoginFeature.State()
                    state.tabBar = nil
                    authStateManager.updateAuthState(.unauthenticated)
                }
                
                return .none
                
            case .authStateChanged(.authenticated):
                state.tabBar = TabBarFeature.State()
                state.login = nil
                return .none
                
            case .authStateChanged(.unauthenticated):
                state.login = LoginFeature.State()
                state.tabBar = nil
                return .none
                
            case .splash, .login, .tabBar:
                return .none
            }
        }
        Scope(state: \.splash, action: \.splash) {
            SplashFeature()
        }
        .ifLet(\.login, action: \.login) {
            LoginFeature()
        }
        .ifLet(\.tabBar, action: \.tabBar) {
            TabBarFeature()
        }
    }
}
