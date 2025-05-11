//
//  Router.swift
//  Homit
//
//  Created by 강민수 on 5/11/25.
//

import Foundation

import Alamofire

protocol Router: URLRequestConvertible {
    associatedtype ErrorType: Error
    
    var url: URL? { get }
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    
    func throwError(data: Data?, statusCode: Int?) -> ErrorType
}
