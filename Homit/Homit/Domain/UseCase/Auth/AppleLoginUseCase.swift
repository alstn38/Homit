//
//  AppleLoginUseCase.swift
//  Homit
//
//  Created by 강민수 on 5/28/25.
//

import Foundation

import AuthenticationServices

protocol AppleLoginUseCase {
    func execute(idToken: String, nickName: String) async throws
}

final class DefaultAppleLoginUseCase: AppleLoginUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(idToken: String, nickName: String) async throws {
        try await authRepository.loginWithApple(
            idToken: idToken,
            nickName: nickName
        )
    }
}
