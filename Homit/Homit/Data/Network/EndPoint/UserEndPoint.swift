//
//  UserEndPoint.swift
//  Homit
//
//  Created by 강민수 on 5/11/25.
//

import Foundation

import Alamofire

enum UserEndPoint: Router {
    case validation(email: String)
    case join(email: String, password: String, nickName: String)
    case emailLogin(email: String, password: String)
    case kakaoLogin(authToken: String)
    case appleLogin(idToken: String, nickName: String)
    case profile(accessToken: String)
    case deviceToken(deviceToken: String, accessToken: String)
    case refreshToken(accessToken: String, refreshToken: String)
}

extension UserEndPoint {
    typealias ErrorType = NetworkError
    
    var url: URL? {
        return URL(string: baseURL + path)
    }
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var path: String {
        switch self {
        case .validation:
            return "/users/validation/email"
        case .join:
            return "/users/join"
        case .emailLogin:
            return "/users/login"
        case .kakaoLogin:
            return "/users/login/kakao"
        case .appleLogin:
            return "/users/login/apple"
        case .profile:
            return "/users/me/profile"
        case .deviceToken:
            return "/users/deviceToken"
        case .refreshToken:
            return "/auth/refresh"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .validation:
            return .post
        case .join:
            return .post
        case .emailLogin:
            return .post
        case .kakaoLogin:
            return .post
        case .appleLogin:
            return .post
        case .profile:
            return .get
        case .deviceToken:
            return .put
        case .refreshToken:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        var headers: HTTPHeaders = [
            "accept": "application/json",
            "Content-Type": "application/json",
            "SeSACKey": Secret.baseURLKey
        ]
        
        if case let .refreshToken(accessToken, refreshToken) = self {
            headers.add(name: "Authorization", value: accessToken)
            headers.add(name: "RefreshToken", value: refreshToken)
        }

        return headers
    }
    
    var parameters: Parameters? {
        switch self {
        case .validation(let email):
            return [
                "email": email
            ]
        case .join(let email, let password, let nickName):
            return [
                "email": email,
                "password": password,
                "nick": nickName
            ]
        case .emailLogin(let email, let password):
            return [
                "email": email,
                "password": password
            ]
        case .kakaoLogin(let authToken):
            return [
                "oauthToken": authToken
            ]
        case .appleLogin(let idToken, let nickName):
            return [
                "idToken": idToken,
                "nick": nickName
            ]
        case .profile:
            return nil
        case .deviceToken(let deviceToken, _):
            return [
                "deviceToken": deviceToken
            ]
        case .refreshToken:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url else {
            throw ErrorType.invalidURL
        }
        
        do {
            var request = try URLRequest(url: url, method: method, headers: headers)
            
            switch method {
            case .get:
                request = try URLEncoding.default.encode(request, with: parameters)
            default:
                request = try JSONEncoding.default.encode(request, with: parameters)
            }
            
            return request
        } catch {
            throw ErrorType.parameterEncodingFailed
        }
    }
    
    func throwError(data: Data?, statusCode: Int?) -> ErrorType {
        let message: String? = {
            guard let data else { return nil }
            return try? JSONDecoder().decode(ErrorResponseDTO.self, from: data).message
        }()
        
        switch statusCode {
        case 400:
            return .badRequest(message: message)
        case 401:
            return .unauthorized(message: message)
        case 409:
            return .conflict(message: message)
        default:
            return .unknown
        }
    }
}
