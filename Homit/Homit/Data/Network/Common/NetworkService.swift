//
//  NetworkService.swift
//  Homit
//
//  Created by 강민수 on 5/11/25.
//

import Foundation

import Alamofire

final class NetworkService {
    
    static let shared = NetworkService()
    
    private let session: Session
    private let sessionWithoutInterceptor: Session
    
    private init() {
        let tokenStorage = DefaultKeychainTokenStorage()
        let interceptor = TokenInterceptor(tokenStorage: tokenStorage)
        self.session = Session(interceptor: interceptor)
        self.sessionWithoutInterceptor = Session()
    }
    
    func request<T: Router, U: Decodable>(
        router: T,
        responseType: U.Type
    ) async throws -> U {
        let dataTask = session.request(router)
            .validate(statusCode: 200..<300)
            .serializingData()

        let response = await dataTask.response

        switch response.result {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(U.self, from: data)
                return decoded
            } catch {
                throw NetworkError.decodeError
            }

        case .failure:
            let statusCode = response.response?.statusCode
            throw router.throwError(data: response.data, statusCode: statusCode)
        }
    }
    
    func requestWithoutInterceptor<T: Router, U: Decodable>(
        router: T,
        responseType: U.Type
    ) async throws -> U {
        let dataTask = sessionWithoutInterceptor.request(router)
            .validate(statusCode: 200..<300)
            .serializingData()

        let response = await dataTask.response

        switch response.result {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(U.self, from: data)
                return decoded
            } catch {
                throw NetworkError.decodeError
            }

        case .failure:
            let statusCode = response.response?.statusCode
            throw router.throwError(data: response.data, statusCode: statusCode)
        }
    }
}
