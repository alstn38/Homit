//
//  DefaultAuthRepository.swift
//  Homit
//
//  Created by 강민수 on 5/13/25.
//

import Foundation

final class DefaultAuthRepository: AuthRepository {
    
    private let keychainTokenStorage: KeychainTokenStorage
    
    init(keychainTokenStorage: KeychainTokenStorage) {
        self.keychainTokenStorage = keychainTokenStorage
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
    
    private func saveToken(from dto: UserLoginDTO) throws {
        try keychainTokenStorage.save(
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken
        )
    }
}
