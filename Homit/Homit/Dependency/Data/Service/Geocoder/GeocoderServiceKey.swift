//
//  GeocoderServiceKey.swift
//  Homit
//
//  Created by 강민수 on 5/31/25.
//

import Foundation

import ComposableArchitecture

private enum GeocoderServiceKey: DependencyKey {
    static var liveValue: GeocoderService {
        DefaultGeocoderService()
    }
}

extension DependencyValues {
    var geocoderService: GeocoderService {
        get { self[GeocoderServiceKey.self] }
        set { self[GeocoderServiceKey.self] = newValue }
    }
}
