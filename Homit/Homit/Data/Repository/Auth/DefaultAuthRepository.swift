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
    
    func signUpWithEmail(email: String, password: String, nickName: String) async throws {
        let router = UserEndPoint.join(
            email: email,
            password: password,
            nickName: nickName
        )
        
        let userJoinDTO = try await NetworkService.shared.request(
            router: router,
            responseType: UserJoinDTO.self
        )
        dump(userJoinDTO)
        
        try saveToken(from: userJoinDTO)
    }
    
    private func saveToken(from dto: UserJoinDTO) throws {
        try keychainTokenStorage.save(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }
}
