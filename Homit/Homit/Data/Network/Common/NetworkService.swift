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
    
    private init() { }
    
    func request<T: Router, U: Decodable>(
        router: T,
        responseType: U.Type
    ) async throws -> U {
        let dataTask = AF.request(router)
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
