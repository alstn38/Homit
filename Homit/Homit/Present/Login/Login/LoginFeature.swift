//
//  LoginFeature.swift
//  Homit
//
//  Created by 강민수 on 5/12/25.
//

import ComposableArchitecture

struct LoginFeature: Reducer {
    
    struct State: Equatable {
        var path = StackState<Path.State>()
        var isLoading: Bool = false
    }
    
    enum Action: Equatable {
        case path(StackActionOf<Path>)
        case appleLoginDidTap
        case kakaoLoginDidTap
        case emailLoginDidTap
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path(let action):
                return .none
            case .appleLoginDidTap:
                return .none
            case .kakaoLoginDidTap:
                return .none
            case .emailLoginDidTap:
                state.path.append(.emailLogin(EmailLoginFeature.State()))
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
    
    struct Path: Reducer {
        enum State: Equatable {
            case emailLogin(EmailLoginFeature.State)
        }

        enum Action: Equatable {
            case emailLogin(EmailLoginFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: /State.emailLogin, action: /Action.emailLogin) {
                EmailLoginFeature()
            }
        }
    }
}
