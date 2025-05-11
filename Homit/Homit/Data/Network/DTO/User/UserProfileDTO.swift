//
//  UserProfileDTO.swift
//  Homit
//
//  Created by 강민수 on 5/11/25.
//

import Foundation

struct UserProfileDTO: Decodable {
    let userId: String
    let email: String
    let nickName: String
    let introduction: String?
    let profileImage: String?
    let phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickName = "nick"
        case introduction
        case profileImage
        case phoneNumber = "phoneNum"
    }
}
