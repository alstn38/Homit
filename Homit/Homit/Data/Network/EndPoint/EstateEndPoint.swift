//
//  EstateEndPoint.swift
//  Homit
//
//  Created by 강민수 on 5/31/25.
//

import Foundation

import Alamofire

enum EstateEndPoint: Router {
    case todayEstate
    case hotEstate
    case todayTopic
}

extension EstateEndPoint {
    typealias ErrorType = NetworkError
    
    var url: URL? {
        return URL(string: baseURL + path)
    }
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var path: String {
        switch self {
        case .todayEstate:
            return "/v1/estates/today-estates"
        case .hotEstate:
            return "/v1/estates/hot-estates"
        case .todayTopic:
            return "/v1/topics/today-topics"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .todayEstate:
            return .get
        case .hotEstate:
            return .get
        case .todayTopic:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Content-Type": "application/json",
            "SeSACKey": Secret.baseURLKey
        ]
        
        return headers
    }
    
    var parameters: Parameters? {
        switch self {
        case .todayEstate:
            return nil
        case .hotEstate:
            return nil
        case .todayTopic:
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
