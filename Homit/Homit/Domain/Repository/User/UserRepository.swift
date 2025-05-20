//
//  UserRepository.swift
//  Homit
//
//  Created by 강민수 on 5/18/25.
//

import Foundation

protocol UserRepository {
    func updateDeviceToken() async throws
}
