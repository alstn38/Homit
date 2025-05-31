//
//  TokenInterceptor.swift
//  Homit
//
//  Created by 강민수 on 5/31/25.
//

import Foundation

import Alamofire

final class TokenInterceptor: RequestInterceptor {
    
    private let tokenStorage: KeychainTokenStorage
    
    init(tokenStorage: KeychainTokenStorage = DefaultKeychainTokenStorage()) {
        self.tokenStorage = tokenStorage
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        /// Authorization 헤더가 이미 있으면 그대로 사용 (EndPoint에서 설정한 토큰)
        if urlRequest.value(forHTTPHeaderField: "Authorization") == nil {
            /// Authorization 헤더가 없으면 AccessToken 추가 시도
            if let accessToken = try? tokenStorage.loadAccessToken() {
                urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
            }
        }
        
        completion(.success(urlRequest))
    }
    
    // MARK: - RequestRetrier
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        guard let response = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetry)
            return
        }
        
        let statusCode = response.statusCode
        
        /// 419: AccessToken 만료 - 토큰 갱신 시도
        if statusCode == 419 {
            /// 토큰 갱신 요청이면 재시도하지 않음 (무한 루프 방지)
            if isRefreshTokenRequest(request) {
                completion(.doNotRetry)
                return
            }
            
            /// AccessToken 갱신 시도
            Task {
                let success = await refreshAccessToken()
                completion(success ? .retry : .doNotRetry)
            }
            return
        }
        
        /// 418: RefreshToken 만료 - 로그아웃 처리
        if statusCode == 418 {
            try? tokenStorage.clear()
            AuthStateManager.shared.updateAuthState(.unauthenticated)
            completion(.doNotRetry)
            return
        }
        
        /// 401: RefreshToken 요청에서 인증 실패 - 로그아웃 처리
        if statusCode == 401 && isRefreshTokenRequest(request) {
            try? tokenStorage.clear()
            AuthStateManager.shared.updateAuthState(.unauthenticated)
            completion(.doNotRetry)
            return
        }
        
        /// 기타 에러는 재시도하지 않음
        completion(.doNotRetry)
    }
    
    /// 토큰 갱신 요청인지 확인
    private func isRefreshTokenRequest(_ request: Request) -> Bool {
        guard let url = request.request?.url?.absoluteString else { return false }
        return url.contains("/v1/auth/refresh")
    }
    
    /// 액세스 토큰 갱신
    private func refreshAccessToken() async -> Bool {
        do {
            let refreshToken = try tokenStorage.loadRefreshToken()
            let router = UserEndPoint.refreshToken(refreshToken: refreshToken)
            
            /// 인터셉터가 없는 별도 세션으로 토큰 갱신 요청
            let response = try await NetworkService.shared.requestWithoutInterceptor(
                router: router,
                responseType: TokenRefreshDTO.self
            )
            
            /// 새로운 토큰 저장
            try tokenStorage.save(
                accessToken: response.accessToken,
                refreshToken: response.refreshToken
            )
            
            return true
            
        } catch {
            /// 토큰 갱신 실패 시 에러 타입에 따라 처리
            if let networkError = error as? NetworkError {
                switch networkError {
                case .unauthorized:
                    try? tokenStorage.clear()
                    AuthStateManager.shared.updateAuthState(.unauthenticated)
                default:
                    print("Token refresh failed due to network error")
                }
            } else {
                try? tokenStorage.clear()
                AuthStateManager.shared.updateAuthState(.unauthenticated)
            }
            
            return false
        }
    }
}
