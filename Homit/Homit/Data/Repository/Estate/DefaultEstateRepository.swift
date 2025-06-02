//
//  DefaultEstateRepository.swift
//  Homit
//
//  Created by 강민수 on 5/31/25.
//

import Foundation

import CoreLocation

final class DefaultEstateRepository: EstateRepository {
    
    private let geocoderService: GeocoderService
    private let recentEstateStorageService: RecentEstateStorageService
    
    init(
        geocoderService: GeocoderService,
        recentEstateStorageService: RecentEstateStorageService
    ) {
        self.geocoderService = geocoderService
        self.recentEstateStorageService = recentEstateStorageService
    }
    
    func getTodayEstates() async throws -> [EstateEntity] {
        let router = EstateEndPoint.todayEstate
        let response = try await NetworkService.shared.request(
            router: router,
            responseType: EstateListDTO.self
        )
        
        return try await convertToEstateEntities(from: response.data)
    }
    
    func getHotEstates() async throws -> [EstateEntity] {
        let router = EstateEndPoint.hotEstate
        let response = try await NetworkService.shared.request(
            router: router,
            responseType: EstateListDTO.self
        )
        
        return try await convertToEstateEntities(from: response.data)
    }
    
    func getTodayTopics() async throws -> [TopicEntity] {
        let router = EstateEndPoint.todayTopic
        let response = try await NetworkService.shared.request(
            router: router,
            responseType: EstateTopicListDTO.self
        )
        
        return response.data.map { dto in
            TopicEntity(
                title: dto.title,
                content: dto.content,
                date: dto.date,
                link: URL(string: dto.link)
            )
        }
    }
    
    func saveRecentEstate(_ estate: EstateEntity) throws {
        try recentEstateStorageService.saveRecentEstate(estate)
    }
    
    func getRecentEstates(limit: Int = 20) -> [EstateEntity] {
        return recentEstateStorageService.fetchRecentEstates(limit: limit)
    }
    
    private func convertToEstateEntities(from dtos: [EstateDTO]) async throws -> [EstateEntity] {
        var entities: [EstateEntity] = []
        
        for dto in dtos {
            let location = CLLocation(
                latitude: dto.geolocation.latitude,
                longitude: dto.geolocation.longitude
            )
            
            let locationEntity = try await geocoderService.reverseGeocode(location: location)
            let thumbnailURLs = dto.thumbnails.compactMap { URL(string: $0) }
            
            let entity = EstateEntity(
                id: dto.estateId,
                category: dto.category,
                title: dto.title,
                introduction: dto.introduction,
                thumbnailURL: thumbnailURLs,
                deposit: dto.deposit,
                monthlyRent: dto.monthlyRent,
                area: dto.area,
                latitude: dto.geolocation.latitude,
                longitude: dto.geolocation.longitude,
                locationEntity: locationEntity,
                isSafeEstate: dto.isSafeEstate,
                isRecommended: dto.isRecommended
            )
            
            entities.append(entity)
        }
        
        return entities
    }
    
    private enum EstateRepositoryError: LocalizedError {
        case serviceUnavailable
        
        var errorDescription: String? {
            switch self {
            case .serviceUnavailable:
                return "서비스를 사용할 수 없습니다."
            }
        }
    }
}
