//
//  KeychainTokenStorageKey.swift
//  Homit
//
//  Created by 강민수 on 5/17/25.
//

import Foundation

import ComposableArchitecture

private enum KeychainTokenStorageKey: DependencyKey {
    static var liveValue: KeychainTokenStorage {
        DefaultKeychainTokenStorage()
    }
}

extension DependencyValues {
    var keychainTokenStorage: KeychainTokenStorage {
        get { self[KeychainTokenStorageKey.self] }
        set { self[KeychainTokenStorageKey.self] = newValue }
    }
}
