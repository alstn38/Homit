//
//  KakaoLoginError.swift
//  Homit
//
//  Created by 강민수 on 5/28/25.
//

import Foundation

enum KakaoLoginError: LocalizedError {
    case loginFailed(String)
    case tokenNotFound
    
    var errorDescription: String? {
        switch self {
        case .loginFailed(let message):
            return "카카오 로그인 실패: \(message)"
        case .tokenNotFound:
            return "카카오 토큰을 찾을 수 없습니다."
        }
    }
}
