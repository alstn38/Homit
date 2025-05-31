//
//  NetworkError.swift
//  Homit
//
//  Created by 강민수 on 5/11/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case parameterEncodingFailed
    case decodeError
    case badRequest(message: String?) // 400
    case unauthorized(message: String?) // 401
    case conflict(message: String?) // 409
    case refreshTokenExpired(message: String?) // 418 - RefreshToken 만료
    case accessTokenExpired(message: String?) // 419 - AccessToken 만료
    case unknown
}

extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 요청입니다."
        case .parameterEncodingFailed:
            return "요청 파라미터 인코딩에 실패했습니다"
        case .decodeError:
            return "데이터를 불러오는 데 문제가 발생했습니다."
        case .badRequest(let message):
            return message ?? "요청이 잘못되었습니다. (400)"
        case .unauthorized(let message):
            return message ?? "인증에 실패했습니다. (401)"
        case .conflict(let message):
            return message ?? "이미 존재하는 항목입니다. (409)"
        case .refreshTokenExpired(let message):
            return message ?? "RefreshToken이 만료되었습니다. (418)"
        case .accessTokenExpired(let message):
            return message ?? "AccessToken이 만료되었습니다. (419)"
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
