//
//  DeviceTokenManager.swift
//  Homit
//
//  Created by 강민수 on 5/18/25.
//

import Foundation

import KeychainAccess

final class DeviceTokenManager {
    
    static let shared = DeviceTokenManager()
    
    private let keychain = Keychain(service: "com.alstn38.homit.app")
    private let deviceTokenKey = "APNSDeviceToken"
    
    private init() {}
    
    func saveDeviceToken(_ token: String) throws {
        do {
            try keychain.set(token, key: deviceTokenKey)
        } catch {
            throw DeviceTokenError.saveFailed
        }
    }
    
    func getDeviceToken() throws -> String {
        do {
            guard let deviceToken = try keychain.get(deviceTokenKey) else {
                throw DeviceTokenError.missingDeviceToken
            }
            return deviceToken
        } catch {
            throw DeviceTokenError.retrieveFailed
        }
    }
    
    private enum DeviceTokenError: LocalizedError {
        case saveFailed
        case retrieveFailed
        case missingDeviceToken
        
        var errorDescription: String? {
            switch self {
            case .saveFailed:
                return "Device Token 저장 실패"
            case .retrieveFailed:
                return "Device Token 조회 실패"
            case .missingDeviceToken:
                return "Device Token이 존재하지 않습니다."
            }
        }
    }
}
