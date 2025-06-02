//
//  RecentEstateStorageService.swift
//  Homit
//
//  Created by 강민수 on 6/1/25.
//

import Foundation

import RealmSwift

protocol RecentEstateStorageService {
    func saveRecentEstate(_ estate: EstateEntity) throws
    func fetchRecentEstates(limit: Int) -> [EstateEntity]
    func deleteRecentEstate(estateID: String) throws
    func clearAllRecentEstates() throws
}

final class DefaultRecentEstateStorageService: RecentEstateStorageService {
    
    private let maxEstateCount = 50 /// 최대 저장할 최근 본 매물 개수
    
    func saveRecentEstate(_ estate: EstateEntity) throws {
        let realm = try! Realm()
        
        do {
            try realm.write {
                if let existingEstate = realm.object(ofType: RecentEstateObject.self, forPrimaryKey: estate.id) {
                    /// 이미 존재하는 매물이면 조회 날짜만 업데이트
                    existingEstate.viewedDate = Date()
                } else {
                    /// 새로운 매물 추가
                    let recentEstateObject = RecentEstateObject(from: estate)
                    realm.add(recentEstateObject)
                    
                    /// 최대 개수 초과 시 가장 오래된 매물 삭제
                    cleanupOldEstatesIfNeeded()
                }
            }
        } catch {
            throw RealmStorageError.realmSaveFailed
        }
    }
    
    func fetchRecentEstates(limit: Int = 20) -> [EstateEntity] {
        let realm = try! Realm()
        
        let results = realm.objects(RecentEstateObject.self)
            .sorted(byKeyPath: "viewedDate", ascending: false)
            .prefix(limit)
        
        return results.map { $0.toEntity() }
    }
    
    func deleteRecentEstate(estateID: String) throws {
        let realm = try! Realm()
        
        guard let object = realm.object(
            ofType: RecentEstateObject.self,
            forPrimaryKey: estateID
        ) else {
            throw RealmStorageError.realmLoadFailed
        }
        
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            throw RealmStorageError.realmDeleteFailed
        }
    }
    
    func clearAllRecentEstates() throws {
        let realm = try! Realm()
        
        let allEstates = realm.objects(RecentEstateObject.self)
        
        do {
            try realm.write {
                realm.delete(allEstates)
            }
        } catch {
            throw RealmStorageError.realmDeleteFailed
        }
    }
    
    private func cleanupOldEstatesIfNeeded() {
        let realm = try! Realm()
        
        let allEstates = realm.objects(RecentEstateObject.self)
            .sorted(byKeyPath: "viewedDate", ascending: false)
        
        if allEstates.count > maxEstateCount {
            let estatesToDelete = Array(allEstates.suffix(from: maxEstateCount))
            realm.delete(estatesToDelete)
        }
    }
}
