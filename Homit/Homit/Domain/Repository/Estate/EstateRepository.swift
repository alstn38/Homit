//
//  EstateRepository.swift
//  Homit
//
//  Created by 강민수 on 5/31/25.
//

import Foundation

protocol EstateRepository {
    /// 메인화면 상단 매물 조회 메서드
    func getTodayEstates() async throws -> [EstateEntity]
    
    /// 부동산 Hot 매물 조회 메서드
    func getHotEstates() async throws -> [EstateEntity]
    
    /// 부동산 오늘의 Topic 조회 메서드
    func getTodayTopics() async throws -> [TopicEntity]
    
    /// 최근 본 매물 저장 메서드
    func saveRecentEstate(_ estate: EstateEntity) throws
    
    /// 최근 본 매물 조회 메서드
    func getRecentEstates(limit: Int) -> [EstateEntity]
}
