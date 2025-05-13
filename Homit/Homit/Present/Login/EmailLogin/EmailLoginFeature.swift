//
//  EmailLoginFeature.swift
//  Homit
//
//  Created by 강민수 on 5/12/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct EmailLoginFeature {
    
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State {
        var email: String = ""
        var password: String = ""
        
        var isValidButton: Bool {
            !email.isEmpty && !password.isEmpty
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case loginButtonDidTap
        case signUpButtonDidTap
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .loginButtonDidTap:
                return .none
                
            case .signUpButtonDidTap:
                return .none
            }
        }
    }
}
