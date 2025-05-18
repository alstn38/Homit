//
//  SignUpFeature.swift
//  Homit
//
//  Created by 강민수 on 5/12/25.
//

import ComposableArchitecture

@Reducer
struct SignUpFeature {
    
    @Dependency(\.emailSignUpUseCase) var emailSignUpUseCase
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        var email: String = ""
        var password: String = ""
        var confirmPassword: String = ""
        var nickName: String = ""
        var isLoading: Bool = false
        
        @Presents
        var alert: AlertState<Action.Alert>?
        
        var isValidButton: Bool {
            return !email.isEmpty && !password.isEmpty
            && password == confirmPassword && !nickName.isEmpty
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case signUpButtonDidTap
        
        case signUpSuccess
        case signUpFailure(String)
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        enum Alert: Equatable {
            case successAlertDismissed
            case errorAlertDismissed
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .signUpButtonDidTap:
                return .run { [
                    email = state.email,
                    password = state.password,
                    nickName = state.nickName
                ] send in
                    do {
                        try await emailSignUpUseCase.execute(
                            email: email,
                            password: password,
                            nickname: nickName
                        )
                        await send(.signUpSuccess)
                    } catch {
                        await send(.signUpFailure(error.localizedDescription))
                    }
                }
                
            case .signUpSuccess:
                state.isLoading = false
                state.alert = AlertState(
                    title: {
                        TextState("회원가입에 성공했습니다.")
                    },
                    actions: {
                        ButtonState(action: .successAlertDismissed) {
                            TextState("확인")
                        }
                    }
                )
                
                return .none
                
            case .signUpFailure(let errorMessage):
                state.isLoading = false
                state.alert = AlertState(
                    title: {
                        TextState("회원가입에 실패했습니다.")
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
                
            case .alert(.presented(.successAlertDismissed)):
                return .run { _ in
                    await self.dismiss()
                }
                
            case .alert(.presented(.errorAlertDismissed)):
                return .none
                
            case .alert(.dismiss):
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
