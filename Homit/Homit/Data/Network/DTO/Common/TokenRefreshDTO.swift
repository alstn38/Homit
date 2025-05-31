//
//  TokenRefreshDTO.swift
//  Homit
//
//  Created by 강민수 on 5/31/25.
//

import Foundation

struct TokenRefreshDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
