//
//  DefaultUserRepository.swift
//  Homit
//
//  Created by 강민수 on 5/18/25.
//

import Foundation

final class DefaultUserRepository: UserRepository {
    
    private let keychainTokenStorage: KeychainTokenStorage
    
    init(keychainTokenStorage: KeychainTokenStorage) {
        self.keychainTokenStorage = keychainTokenStorage
    }
    
    func updateDeviceToken() async throws {
        let deviceToken = try DeviceTokenManager.shared.getDeviceToken()
        let accessToken = try keychainTokenStorage.loadAccessToken()
        let router = UserEndPoint.deviceToken(deviceToken: deviceToken, accessToken: accessToken)
        
        _ = try await NetworkService.shared.request(router: router, responseType: EmptyResponseDTO.self)
    }
}
