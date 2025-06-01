//
//  GeocoderService.swift
//  Homit
//
//  Created by 강민수 on 5/31/25.
//

import CoreLocation

protocol GeocoderService {
    func reverseGeocode(location: CLLocation) async throws -> LocationEntity
}

final class DefaultGeocoderService: GeocoderService {
    
    private let geocoder = CLGeocoder()
    
    func reverseGeocode(location: CLLocation) async throws -> LocationEntity {
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    continuation.resume(throwing: GeocoderError.reverseGeocodingFailed(error.localizedDescription))
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    continuation.resume(throwing: GeocoderError.noPlacemarkFound)
                    return
                }
                
                let cityName = placemark.administrativeArea ?? ""
                let townName = placemark.subLocality ?? placemark.locality ?? ""
                
                let locationEntity = LocationEntity(
                    cityName: cityName,
                    townName: townName
                )
                
                continuation.resume(returning: locationEntity)
            }
        }
    }
}
