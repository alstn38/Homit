//
//  UserJoinDTO.swift
//  Homit
//
//  Created by 강민수 on 5/11/25.
//

import Foundation

struct UserJoinDTO: Decodable {
    let userId: String
    let email: String
    let nickName: String
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickName = "nick"
        case accessToken
        case refreshToken
    }
}
