//
//  KeychainTokenStorage.swift
//  Homit
//
//  Created by 강민수 on 5/13/25.
//

import KeychainAccess

protocol KeychainTokenStorage {
    func save(accessToken: String, refreshToken: String) throws
    func loadAccessToken() throws -> String
    func loadRefreshToken() throws -> String
    func clear() throws
}

final class DefaultKeychainTokenStorage: KeychainTokenStorage {
    
    private let keychain = Keychain(service: "com.alstn38.homit.app")
    
    private enum KeychainKey {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
    }
    
    func save(accessToken: String, refreshToken: String) throws {
        do {
            try keychain.set(accessToken, key: KeychainKey.accessToken)
            try keychain.set(refreshToken, key: KeychainKey.refreshToken)
        } catch {
            throw KeychainTokenError.keychainFailure(message: error.localizedDescription)
        }
    }
    
    func loadAccessToken() throws -> String {
        guard let accessToken = try keychain.get(KeychainKey.accessToken) else {
            throw KeychainTokenError.missingAccessToken
        }
        return accessToken
    }
    
    func loadRefreshToken() throws -> String {
        guard let refreshToken = try keychain.get(KeychainKey.refreshToken) else {
            throw KeychainTokenError.missingRefreshToken
        }
        return refreshToken
    }
    
    func clear() throws {
        do {
            try keychain.remove(KeychainKey.accessToken)
            try keychain.remove(KeychainKey.refreshToken)
        } catch {
            throw KeychainTokenError.keychainFailure(message: error.localizedDescription)
        }
    }
}
