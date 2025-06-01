//
//  GeocoderError.swift
//  Homit
//
//  Created by 강민수 on 5/31/25.
//

import Foundation

enum GeocoderError: LocalizedError {
    case reverseGeocodingFailed(String)
    case noPlacemarkFound
    
    var errorDescription: String? {
        switch self {
        case .reverseGeocodingFailed(let message):
            return "위치 변환 실패: \(message)"
        case .noPlacemarkFound:
            return "해당 위치의 주소를 찾을 수 없습니다."
        }
    }
}
