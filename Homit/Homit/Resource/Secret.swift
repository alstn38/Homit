//
//  Secret.swift
//  Homit
//
//  Created by 강민수 on 5/11/25.
//

import Foundation

enum Secret {
    
    static let baseURL: String = {
        guard let urlString = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
            fatalError("BASE_URL ERROR")
        }
        return urlString
    }()
    
    static let baseURLKey: String = {
        guard let urlString = Bundle.main.infoDictionary?["BASE_URL_KEY"] as? String else {
            fatalError("BASE_URL_KEY ERROR")
        }
        return urlString
    }()
}
