//
//  EstateEntity.swift
//  Homit
//
//  Created by 강민수 on 5/31/25.
//

import Foundation

struct EstateEntity: Equatable {
    let id: String                /// 매물의 고유 ID
    let category: String          /// 카테고리 (예: 아파트)
    let title: String             /// 제목
    let introduction: String      /// 소개 문구
    let thumbnailURL: [URL]       /// 썸네일 이미지 전체 URL
    let deposit: Int              /// 보증금
    let monthlyRent: Int          /// 월세
    let area: Double              /// 전용 면적 (㎡)
    let latitude: Double          /// 위도
    let longitude: Double         /// 경도
    let locationEntity: LocationEntity
    let isSafeEstate: Bool        /// 안전 매물 여부
    let isRecommended: Bool       /// 추천 매물 여부
}

struct LocationEntity: Equatable {
    let cityName: String          /// 도시 이름 (예: 서울특별시)
    let townName: String          /// 읍면동 이름 (예: 반포동)
}
