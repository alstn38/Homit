//
//  LoginFeature.swift
//  Homit
//
//  Created by 강민수 on 5/12/25.
//

import AuthenticationServices
import ComposableArchitecture

@Reducer
struct LoginFeature {
    
    @Dependency(\.authRepository) var authRepository
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var isLoading: Bool = false
        
        @Presents
        var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case appleLogin(idToken: String, nickName: String)
        case kakaoLoginDidTap
        case emailLoginDidTap
        
        case appleLoginSuccess
        case appleLoginFailure(String)
        
        case kakaoLoginSuccess
        case kakaoLoginFailure(String)
        
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        enum Alert: Equatable {
            case errorAlertDismissed
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path(.element(id: _, action: .emailLogin(.signUpButtonDidTap))):
                state.path.append(.signUp(SignUpFeature.State()))
                return .none
                
            case .path:
                return .none
                
            case .appleLogin(let idToken, let nickName):
                state.isLoading = true
                
                return .run { send in
                    do {
                        try await authRepository.loginWithApple(
                            idToken: idToken,
                            nickName: nickName
                        )
                        await send(.appleLoginSuccess)
                    } catch {
                        await send(.appleLoginFailure(error.localizedDescription))
                    }
                }
                
            case .kakaoLoginDidTap:
                state.isLoading = true
                
                return .run { send in
                    do {
                        try await authRepository.loginWithKakao()
                        await send(.kakaoLoginSuccess)
                    } catch {
                        await send(.kakaoLoginFailure(error.localizedDescription))
                    }
                }
                
            case .emailLoginDidTap:
                state.path.append(.emailLogin(EmailLoginFeature.State()))
                return .none
                
            case .appleLoginSuccess:
                state.isLoading = false
                return .none
                
            case .appleLoginFailure(let errorMessage):
                state.isLoading = false
                state.alert = AlertState(
                    title: {
                        TextState("애플 로그인 실패")
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
                
            case .kakaoLoginSuccess:
                state.isLoading = false
                return .none
                
            case .kakaoLoginFailure(let errorMessage):
                state.isLoading = false
                state.alert = AlertState(
                    title: {
                        TextState("카카오 로그인 실패")
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
        .forEach(\.path, action: \.path)
        .ifLet(\.$alert, action: \.alert)
    }
    
    @Reducer
    enum Path {
        case emailLogin(EmailLoginFeature)
        case signUp(SignUpFeature)
    }
}
