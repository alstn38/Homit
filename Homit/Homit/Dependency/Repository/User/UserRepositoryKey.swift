//
//  UserRepositoryKey.swift
//  Homit
//
//  Created by 강민수 on 5/18/25.
//

import Foundation

import ComposableArchitecture

private enum UserRepositoryKey: DependencyKey {
    static var liveValue: UserRepository {
        DefaultUserRepository(
            keychainTokenStorage: DependencyValues.live.keychainTokenStorage
        )
    }
}

extension DependencyValues {
    var userRepository: UserRepository {
        get { self[UserRepositoryKey.self] }
        set { self[UserRepositoryKey.self] = newValue }
    }
}
