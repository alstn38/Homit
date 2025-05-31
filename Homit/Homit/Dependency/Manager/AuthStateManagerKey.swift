//
//  AuthStateManagerKey.swift
//  Homit
//
//  Created by 강민수 on 5/31/25.
//

import Foundation

import ComposableArchitecture

private enum AuthStateManagerKey: DependencyKey {
    static var liveValue: AuthStateManager {
        AuthStateManager.shared
    }
}

extension DependencyValues {
    var authStateManager: AuthStateManager {
        get { self[AuthStateManagerKey.self] }
        set { self[AuthStateManagerKey.self] = newValue }
    }
}
