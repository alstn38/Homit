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
        
        case loginSuccessful
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .splash(.proceedToNextScreen):
                switch state.splash.authState {
                case .authenticated:
                    state.tabBar = TabBarFeature.State()
                    state.login = nil
                    
                case .unauthenticated:
                    state.login = LoginFeature.State()
                    state.tabBar = nil
                }
                
                return .none
                
            case .login(.path(.element(id: _, action: .emailLogin(.loginSuccess)))):
                return .send(.loginSuccessful)
                
            case .login(.appleLoginSuccess):
                return .send(.loginSuccessful)
                
            case .login(.kakaoLoginSuccess):
                return .send(.loginSuccessful)
                
            case .splash, .login, .tabBar:
                return .none
                
            case .loginSuccessful:
                state.tabBar = TabBarFeature.State()
                state.login = nil
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
