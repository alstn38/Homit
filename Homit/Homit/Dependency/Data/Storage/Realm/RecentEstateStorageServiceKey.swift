//
//  RecentEstateStorageServiceKey.swift
//  Homit
//
//  Created by 강민수 on 6/1/25.
//

import Foundation

import ComposableArchitecture

private enum RecentEstateStorageServiceKey: DependencyKey {
    static var liveValue: RecentEstateStorageService {
        do {
            return try DefaultRecentEstateStorageService()
        } catch {
            fatalError("Failed to initialize RecentEstateStorageService: \(error)")
        }
    }
}

extension DependencyValues {
    var recentEstateStorageService: RecentEstateStorageService {
        get { self[RecentEstateStorageServiceKey.self] }
        set { self[RecentEstateStorageServiceKey.self] = newValue }
    }
}
