//
//  EmailSignUpUseCaseKey.swift
//  Homit
//
//  Created by 강민수 on 5/17/25.
//

import Foundation

import ComposableArchitecture

private enum EmailSignUpUseCaseKey: DependencyKey {
    static var liveValue: EmailSignUpUseCase {
        DefaultEmailSignUpUseCase(
            authRepository: DependencyValues.live.authRepository
        )
    }
}

extension DependencyValues {
    var emailSignUpUseCase: EmailSignUpUseCase {
        get { self[EmailSignUpUseCaseKey.self] }
        set { self[EmailSignUpUseCaseKey.self] = newValue }
    }
}
