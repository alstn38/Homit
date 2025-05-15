//
//  KeychainTokenError.swift
//  Homit
//
//  Created by 강민수 on 5/13/25.
//

import Foundation

enum KeychainTokenError: LocalizedError {
    case missingAccessToken
    case missingRefreshToken
    case keychainFailure(message: String?)

    var errorDescription: String? {
        switch self {
        case .missingAccessToken:
            return "Access token이 존재하지 않습니다."
        case .missingRefreshToken:
            return "Refresh token이 존재하지 않습니다."
        case .keychainFailure(let message):
            return "Keychain 작업 실패: \(message ?? "알 수 없는 오류")"
        }
    }
}
