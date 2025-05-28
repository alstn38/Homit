//
//  AppleLoginUseCaseKey.swift
//  Homit
//
//  Created by 강민수 on 5/28/25.
//

import Foundation

import ComposableArchitecture

private enum AppleLoginUseCaseKey: DependencyKey {
    static var liveValue: AppleLoginUseCase {
        DefaultAppleLoginUseCase(
            authRepository: DependencyValues.live.authRepository
        )
    }
}

extension DependencyValues {
    var appleLoginUseCase: AppleLoginUseCase {
        get { self[AppleLoginUseCaseKey.self] }
        set { self[AppleLoginUseCaseKey.self] = newValue }
    }
}
