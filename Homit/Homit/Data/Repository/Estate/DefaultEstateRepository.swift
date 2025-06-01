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
        return try await withThrowingTaskGroup(of: EstateEntity.self) { group in
            for dto in dtos {
                group.addTask { [weak self] in
                    guard let self else {
                        throw EstateRepositoryError.serviceUnavailable
                    }
                    
                    let location = CLLocation(
                        latitude: dto.geolocation.latitude,
                        longitude: dto.geolocation.longitude
                    )
                    
                    let locationEntity = try await self.geocoderService.reverseGeocode(location: location)
                    let thumbnailURLs = dto.thumbnails.compactMap { URL(string: $0) }
                    
                    return EstateEntity(
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
                }
            }
            
            /// 모든 결과를 수집하고 원래 순서대로 정렬
            var entities: [EstateEntity] = []
            for try await entity in group {
                entities.append(entity)
            }
            
            /// DTO의 원래 순서와 맞추기 위해 ID로 정렬
            return entities.sorted { entity1, entity2 in
                let index1 = dtos.firstIndex { $0.estateId == entity1.id } ?? 0
                let index2 = dtos.firstIndex { $0.estateId == entity2.id } ?? 0
                return index1 < index2
            }
        }
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
