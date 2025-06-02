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
    
    /// 토큰 재발급 동기화를 위한 큐
    private let tokenRefreshQueue = DispatchQueue(label: "TokenRefreshQueue", attributes: .concurrent)
    
    /// 현재 토큰 재발급이 진행 중인지 확인하는 플래그
    private var isRefreshing = false
    
    /// 토큰 재발급을 기다리는 요청들의 컴플리션 핸들러를 저장하는 배열
    private var pendingRequests: [(RetryResult) -> Void] = []
    
    init(tokenStorage: KeychainTokenStorage = DefaultKeychainTokenStorage()) {
        self.tokenStorage = tokenStorage
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        if let accessToken = try? tokenStorage.loadAccessToken() {
            urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(urlRequest))
    }
    
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
            
            handleTokenRefresh(completion: completion)
            return
        }
        
        /// 418: RefreshToken 만료 - 로그아웃 처리
        if statusCode == 418 {
            handleLogout()
            completion(.doNotRetry)
            return
        }
        
        /// 401: RefreshToken 요청에서 인증 실패 - 로그아웃 처리
        if statusCode == 401 && isRefreshTokenRequest(request) {
            handleLogout()
            completion(.doNotRetry)
            return
        }
        
        /// 기타 에러는 재시도하지 않음
        completion(.doNotRetry)
    }
    
    /// 토큰 재발급 처리 (큐를 이용한 동기화)
    private func handleTokenRefresh(completion: @escaping (RetryResult) -> Void) {
        tokenRefreshQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else {
                completion(.doNotRetry)
                return
            }
            
            /// 이미 토큰 재발급이 진행 중이면 대기 큐에 추가
            if self.isRefreshing {
                self.pendingRequests.append(completion)
                return
            }
            
            /// 토큰 재발급 시작
            self.isRefreshing = true
            
            /// 현재 요청을 대기 큐에 추가 (첫 번째 요청도 동일하게 처리)
            self.pendingRequests.append(completion)
            
            /// 실제 토큰 재발급 수행
            Task {
                let success = await self.performTokenRefresh()
                
                /// 메인 큐에서 결과 처리
                DispatchQueue.main.async {
                    self.tokenRefreshQueue.async(flags: .barrier) {
                        self.processRefreshResult(success: success)
                    }
                }
            }
        }
    }
    
    /// 토큰 재발급 결과 처리
    private func processRefreshResult(success: Bool) {
        let result: RetryResult = success ? .retry : .doNotRetry
        let requestCount = pendingRequests.count
        
        /// 대기 중인 모든 요청들에게 결과 전달
        for pendingCompletion in pendingRequests {
            pendingCompletion(result)
        }
        
        /// 대기 큐 초기화 및 플래그 리셋
        pendingRequests.removeAll()
        isRefreshing = false
    }
    
    /// 실제 토큰 재발급 수행
    private func performTokenRefresh() async -> Bool {
        do {
            let accessToken = try tokenStorage.loadAccessToken()
            let refreshToken = try tokenStorage.loadRefreshToken()
            let router = UserEndPoint.refreshToken(accessToken: accessToken, refreshToken: refreshToken)
            
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
            handleLogout()
            return false
        }
    }
    
    /// 로그아웃 처리
    private func handleLogout() {
        try? tokenStorage.clear()
        
        DispatchQueue.main.async {
            AuthStateManager.shared.updateAuthState(.unauthenticated)
        }
        
        /// 진행 중인 토큰 재발급 취소
        tokenRefreshQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            
            /// 대기 중인 모든 요청들을 실패 처리
            for pendingCompletion in self.pendingRequests {
                pendingCompletion(.doNotRetry)
            }
            
            self.pendingRequests.removeAll()
            self.isRefreshing = false
        }
    }
    
    /// 토큰 갱신 요청인지 확인
    private func isRefreshTokenRequest(_ request: Request) -> Bool {
        guard let url = request.request?.url?.absoluteString else { return false }
        return url.contains("/v1/auth/refresh")
    }
}
