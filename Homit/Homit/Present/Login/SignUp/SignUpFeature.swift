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
        var error: String? = nil
        
        var isValidButton: Bool {
            return !email.isEmpty && !password.isEmpty
            && password == confirmPassword && !nickName.isEmpty
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case signUpButtonDidTap
        case signUpSuccess
        case signUpFailure(Error)
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
                        await send(.signUpFailure(error))
                    }
                }
                
            case .signUpSuccess:
                state.isLoading = false
                return .run { _ in
                    await self.dismiss()
                }
                
            case .signUpFailure(let error):
                state.isLoading = false
                state.error = error.localizedDescription
                return .none
            }
        }
    }
}
