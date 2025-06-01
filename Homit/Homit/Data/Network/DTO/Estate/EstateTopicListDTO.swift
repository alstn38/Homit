//
//  EstateTopicListDTO.swift
//  Homit
//
//  Created by 강민수 on 5/31/25.
//

import Foundation

struct EstateTopicListDTO: Decodable {
    let data: [EstateTopicDTO]
}

struct EstateTopicDTO: Decodable {
    let title: String
    let content: String
    let date: String
    let link: String
}
