//
//  KakaoLoginService.swift
//  Homit
//
//  Created by 강민수 on 5/28/25.
//

import Foundation

import KakaoSDKAuth
import KakaoSDKUser

protocol KakaoLoginService {
    func login() async throws -> String
}

final class DefaultKakaoLoginService: KakaoLoginService {
    
    func login() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                /// 카카오톡 설치 여부 확인
                if UserApi.isKakaoTalkLoginAvailable() {
                    /// 카카오톡으로 로그인
                    UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                        if let error = error {
                            continuation.resume(throwing: KakaoLoginError.loginFailed(error.localizedDescription))
                        } else if let token = oauthToken?.accessToken {
                            continuation.resume(returning: token)
                        } else {
                            continuation.resume(throwing: KakaoLoginError.tokenNotFound)
                        }
                    }
                } else {
                    /// 카카오 계정으로 로그인
                    UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                        if let error = error {
                            continuation.resume(throwing: KakaoLoginError.loginFailed(error.localizedDescription))
                        } else if let token = oauthToken?.accessToken {
                            continuation.resume(returning: token)
                        } else {
                            continuation.resume(throwing: KakaoLoginError.tokenNotFound)
                        }
                    }
                }
            }
        }
    }
}
