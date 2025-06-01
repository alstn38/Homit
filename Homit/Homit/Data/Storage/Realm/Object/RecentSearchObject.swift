//
//  RecentSearchObject.swift
//  Homit
//
//  Created by 강민수 on 6/1/25.
//

import Foundation

import RealmSwift

final class RecentEstateObject: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var category: String
    @Persisted var title: String
    @Persisted var introduction: String
    @Persisted var thumbnailURLs: List<String> = List<String>()
    @Persisted var deposit: Int
    @Persisted var monthlyRent: Int
    @Persisted var area: Double
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var cityName: String
    @Persisted var townName: String
    @Persisted var isSafeEstate: Bool
    @Persisted var isRecommended: Bool
    @Persisted var viewedDate: Date
    
    convenience init(from entity: EstateEntity) {
        self.init()
        self.id = entity.id
        self.category = entity.category
        self.title = entity.title
        self.introduction = entity.introduction
        self.thumbnailURLs.append(objectsIn: entity.thumbnailURL.map { $0.absoluteString })
        self.deposit = entity.deposit
        self.monthlyRent = entity.monthlyRent
        self.area = entity.area
        self.latitude = entity.latitude
        self.longitude = entity.longitude
        self.cityName = entity.locationEntity.cityName
        self.townName = entity.locationEntity.townName
        self.isSafeEstate = entity.isSafeEstate
        self.isRecommended = entity.isRecommended
        self.viewedDate = Date()
    }
}

extension RecentEstateObject {
    
    func toEntity() -> EstateEntity {
        let thumbnailURLs = Array(self.thumbnailURLs).compactMap { URL(string: $0) }
        let locationEntity = LocationEntity(cityName: cityName, townName: townName)
        
        return EstateEntity(
            id: id,
            category: category,
            title: title,
            introduction: introduction,
            thumbnailURL: thumbnailURLs,
            deposit: deposit,
            monthlyRent: monthlyRent,
            area: area,
            latitude: latitude,
            longitude: longitude,
            locationEntity: locationEntity,
            isSafeEstate: isSafeEstate,
            isRecommended: isRecommended
        )
    }
}
