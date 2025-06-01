//
//  EstateListDTO.swift
//  Homit
//
//  Created by 강민수 on 5/31/25.
//

import Foundation

struct EstateListDTO: Decodable {
    let data: [EstateDTO]
}

struct EstateDTO: Decodable {
    let estateId: String
    let category: String
    let title: String
    let introduction: String
    let thumbnails: [String]
    let deposit: Int
    let monthlyRent: Int
    let builtYear: String
    let area: Double
    let floors: Int
    let geolocation: GeolocationDTO
    let likeCount: Int
    let isSafeEstate: Bool
    let isRecommended: Bool
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case estateId = "estate_id"
        case category
        case title
        case introduction
        case thumbnails
        case deposit
        case monthlyRent = "monthly_rent"
        case builtYear = "built_year"
        case area
        case floors
        case geolocation
        case likeCount = "like_count"
        case isSafeEstate = "is_safe_estate"
        case isRecommended = "is_recommended"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct GeolocationDTO: Decodable {
    let longitude: Double
    let latitude: Double
}
