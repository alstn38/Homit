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
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            
            guard let placemark = placemarks.first else {
                throw GeocoderError.noPlacemarkFound
            }
            
            let cityName = placemark.administrativeArea ?? ""
            let townName = placemark.subLocality ?? placemark.locality ?? ""
            
            return LocationEntity(
                cityName: cityName,
                townName: townName
            )
        } catch {
            if error is GeocoderError {
                throw error
            } else {
                throw GeocoderError.reverseGeocodingFailed(error.localizedDescription)
            }
        }
    }
}
