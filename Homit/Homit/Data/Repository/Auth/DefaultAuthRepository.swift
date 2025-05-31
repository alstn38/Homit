//
//  DefaultAuthRepository.swift
//  Homit
//
//  Created by 강민수 on 5/13/25.
//

import Foundation

final class DefaultAuthRepository: AuthRepository {
    
    private let keychainTokenStorage: KeychainTokenStorage
    private let kakaoLoginService: KakaoLoginService
    private let authStateManager: AuthStateManager
    
    init(
        keychainTokenStorage: KeychainTokenStorage,
        kakaoLoginService: KakaoLoginService,
        authStateManager: AuthStateManager = AuthStateManager.shared
    ) {
        self.keychainTokenStorage = keychainTokenStorage
        self.kakaoLoginService = kakaoLoginService
        self.authStateManager = authStateManager
    }
    
    func isAuthenticated() -> Bool {
        do {
            _ = try keychainTokenStorage.loadAccessToken()
            return true
        } catch {
            return false
        }
    }
    
    func signUpWithEmail(email: String, password: String, nickName: String) async throws {
        let router = UserEndPoint.join(
            email: email,
            password: password,
            nickName: nickName
        )
        
        _ = try await NetworkService.shared.request(
            router: router,
            responseType: UserJoinDTO.self
        )
    }
    
    func loginWithEmail(email: String, password: String) async throws {
        let router = UserEndPoint.emailLogin(
            email: email,
            password: password
        )
        
        let response = try await NetworkService.shared.request(
            router: router,
            responseType: UserLoginDTO.self
        )
        
        try saveToken(from: response)
        authStateManager.updateAuthState(.authenticated)
    }
    
    func loginWithApple(idToken: String, nickName: String) async throws {
        let router = UserEndPoint.appleLogin(
            idToken: idToken,
            nickName: nickName
        )
        
        let response = try await NetworkService.shared.request(
            router: router,
            responseType: UserLoginDTO.self
        )
        
        try saveToken(from: response)
        authStateManager.updateAuthState(.authenticated)
    }
    
    func loginWithKakao() async throws {
        let kakaoToken = try await kakaoLoginService.login()
        
        let router = UserEndPoint.kakaoLogin(authToken: kakaoToken)
        
        let response = try await NetworkService.shared.request(
            router: router,
            responseType: UserLoginDTO.self
        )
        
        try saveToken(from: response)
        authStateManager.updateAuthState(.authenticated)
    }
    
    func logout() throws {
        try keychainTokenStorage.clear()
        authStateManager.updateAuthState(.unauthenticated)
    }
    
    private func saveToken(from dto: UserLoginDTO) throws {
        try keychainTokenStorage.save(
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken
        )
    }
}
