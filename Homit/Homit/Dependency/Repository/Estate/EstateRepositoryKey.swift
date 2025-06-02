//
//  EstateRepositoryKey.swift
//  Homit
//
//  Created by 강민수 on 5/31/25.
//

import Foundation

import ComposableArchitecture

private enum EstateRepositoryKey: DependencyKey {
    static var liveValue: EstateRepository {
        DefaultEstateRepository(
            geocoderService: DependencyValues.live.geocoderService,
            recentEstateStorageService: DependencyValues.live.recentEstateStorageService
        )
    }
}

extension DependencyValues {
    var estateRepository: EstateRepository {
        get { self[EstateRepositoryKey.self] }
        set { self[EstateRepositoryKey.self] = newValue }
    }
}
