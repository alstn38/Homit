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
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
