//
//  LoginFeature.swift
//  Homit
//
//  Created by 강민수 on 5/12/25.
//

import ComposableArchitecture

@Reducer
struct LoginFeature {
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var isLoading: Bool = false
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case appleLoginDidTap
        case kakaoLoginDidTap
        case emailLoginDidTap
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path(.element(id: _, action: .emailLogin(.signUpButtonDidTap))):
                state.path.append(.signUp(SignUpFeature.State()))
                return .none
                
            case .path:
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
        .forEach(\.path, action: \.path)
    }
    
    @Reducer
    enum Path {
        case emailLogin(EmailLoginFeature)
        case signUp(SignUpFeature)
    }
}
