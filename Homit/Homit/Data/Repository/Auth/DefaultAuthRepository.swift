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
    
    init(
        keychainTokenStorage: KeychainTokenStorage,
        kakaoLoginService: KakaoLoginService
    ) {
        self.keychainTokenStorage = keychainTokenStorage
        self.kakaoLoginService = kakaoLoginService
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
    }
    
    func loginWithKakao() async throws {
        let kakaoToken = try await kakaoLoginService.login()
        
        let router = UserEndPoint.kakaoLogin(authToken: kakaoToken)
        
        let response = try await NetworkService.shared.request(
            router: router,
            responseType: UserLoginDTO.self
        )
        
        try saveToken(from: response)
    }
    
    private func saveToken(from dto: UserLoginDTO) throws {
        try keychainTokenStorage.save(
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken
        )
    }
}
