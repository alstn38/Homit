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
        DefaultRecentEstateStorageService()
    }
}

extension DependencyValues {
    var recentEstateStorageService: RecentEstateStorageService {
        get { self[RecentEstateStorageServiceKey.self] }
        set { self[RecentEstateStorageServiceKey.self] = newValue }
    }
}
