//
//  Kingfisher+.swift
//  Homit
//
//  Created by 강민수 on 6/2/25.
//

import Foundation

import Kingfisher

struct AuthRequestModifier: AsyncImageDownloadRequestModifier {
    var onDownloadTaskStarted: (@Sendable (Kingfisher.DownloadTask?) -> Void)?
    
    func modified(for request: URLRequest) async -> URLRequest? {
        var mutableRequest = request
        
        /// URL 보정 (필요할 경우)
        if let originalURL = request.url?.absoluteString,
           !originalURL.hasPrefix(Secret.baseURL),
           let fullURL = URL(string: Secret.baseURL + originalURL) {
            mutableRequest.url = fullURL
        }
        
        /// AccessToken 헤더 추가
        if let accessToken = try? DefaultKeychainTokenStorage().loadAccessToken() {
            mutableRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
            mutableRequest.setValue(Secret.baseURLKey, forHTTPHeaderField: "SeSACKey")
        }
        
        return mutableRequest
    }
}
