//
//  AuthRepositoryKey.swift
//  Homit
//
//  Created by 강민수 on 5/17/25.
//

import Foundation

import ComposableArchitecture

private enum AuthRepositoryKey: DependencyKey {
    static var liveValue: AuthRepository {
        DefaultAuthRepository(
            keychainTokenStorage: DependencyValues.live.keychainTokenStorage,
            kakaoLoginService: DependencyValues.live.kakaoLoginService
        )
    }
}

extension DependencyValues {
    var authRepository: AuthRepository {
        get { self[AuthRepositoryKey.self] }
        set { self[AuthRepositoryKey.self] = newValue }
    }
}
