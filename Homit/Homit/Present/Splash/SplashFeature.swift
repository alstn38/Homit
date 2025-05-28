//
//  SplashFeature.swift
//  Homit
//
//  Created by 강민수 on 5/18/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct SplashFeature {
    
    @Dependency(\.authRepository) var authRepository
    @Dependency(\.userRepository) var userRepository
    @Dependency(\.continuousClock) var clock
    
    @ObservableState
    struct State: Equatable {
        var authState: AuthState = .unauthenticated
        var isLoading: Bool = true
        var error: String? = nil
    }
    
    enum Action {
        case onAppear
        case checkAuthState
        case authStateResult(AuthState)
        case registerDeviceToken
        case successDeviceTokenRegistration
        case failDeviceTokenRegistration
        case proceedToNextScreen
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.checkAuthState)
                
            case .checkAuthState:
                state.isLoading = true
                
                return .run { send in
                    /// 스플래시 화면 최소 시간
                    try await self.clock.sleep(for: .seconds(1))
                    
                    if authRepository.isAuthenticated() {
                        await send(.authStateResult(.authenticated))
                    } else {
                        await send(.authStateResult(.unauthenticated))
                    }
                }
                
            case .authStateResult(let authState):
                state.authState = authState
                
                /// 인증된 상태라면 디바이스 토큰 등록 시도
                if authState == .authenticated {
                    return .send(.registerDeviceToken)
                } else {
                    state.isLoading = false
                    return .send(.proceedToNextScreen)
                }
                
            case .registerDeviceToken:
                return .run { send in
                    do {
                        try await self.userRepository.updateDeviceToken()
                        await send(.successDeviceTokenRegistration)
                    } catch {
                        await send(.failDeviceTokenRegistration)
                    }
                }
                
            case .successDeviceTokenRegistration:
                state.isLoading = false
                state.authState = .authenticated
                return .send(.proceedToNextScreen)
                
            case .failDeviceTokenRegistration:
                state.isLoading = false
                state.authState = .unauthenticated
                return .send(.proceedToNextScreen)
                
            case .proceedToNextScreen:
                return .none
            }
        }
    }
    
    enum AuthState {
        case authenticated
        case unauthenticated
    }
}
