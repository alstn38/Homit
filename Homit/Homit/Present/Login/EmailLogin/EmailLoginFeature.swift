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
    @Dependency(\.authRepository) var authRepository
    
    @ObservableState
    struct State {
        var email: String = ""
        var password: String = ""
        var isLoading: Bool = false
        
        @Presents
        var alert: AlertState<Action.Alert>?
        
        var isValidButton: Bool {
            !email.isEmpty && !password.isEmpty
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case loginButtonDidTap
        case signUpButtonDidTap
        
        case loginSuccess
        case loginFailure(String)
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        enum Alert: Equatable {
            case errorAlertDismissed
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .loginButtonDidTap:
                state.isLoading = true
                
                return .run { [email = state.email, password = state.password] send in
                    do {
                        try await authRepository.loginWithEmail(email: email, password: password)
                        await send(.loginSuccess)
                    } catch {
                        await send(.loginFailure(error.localizedDescription))
                    }
                }
                
            case .signUpButtonDidTap:
                return .none
                
            case .loginSuccess:
                state.isLoading = false
                return .none
                
            case .loginFailure(let errorMessage):
                state.isLoading = false
                state.alert = AlertState(
                    title: {
                        TextState("로그인 실패")
                    },
                    actions: {
                        ButtonState(role: .cancel, action: .errorAlertDismissed) {
                            TextState("확인")
                        }
                    },
                    message: {
                        TextState(errorMessage)
                    }
                )
                return .none
                
            case .alert(.presented(.errorAlertDismissed)):
                return .none
                
            case .alert(.dismiss):
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
