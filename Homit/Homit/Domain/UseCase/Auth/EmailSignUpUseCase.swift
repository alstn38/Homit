//
//  EmailSignUpUseCase.swift
//  Homit
//
//  Created by 강민수 on 5/13/25.
//

import Foundation

protocol EmailSignUpUseCase {
    func execute(email: String, password: String, nickname: String) async throws
}

final class DefaultEmailSignUpUseCase: EmailSignUpUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(email: String, password: String, nickname: String) async throws {
        guard isValidNickname(nickname) else {
            throw EmailSignUpError.invalidNickname
        }
        
        guard isValidEmail(email) else {
            throw EmailSignUpError.invalidEmail
        }
        
        guard isValidPassword(password) else {
            throw EmailSignUpError.invalidPassword
        }
        
        try await authRepository.signUpWithEmail(
            email: email,
            password: password,
            nickName: nickname
        )
    }
    
    private func isValidNickname(_ nickname: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: ".,?*-@")
        return nickname.rangeOfCharacter(from: invalidCharacters) == nil
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: regex, options: .regularExpression) != nil
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let regex = #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$"#
        return password.range(of: regex, options: .regularExpression) != nil
    }
    
    private enum EmailSignUpError: Error {
        case invalidNickname
        case invalidEmail
        case invalidPassword
        
        var errorDescription: String? {
            switch self {
            case .invalidNickname:
                return "닉네임에는 ., ,, ?, *, -, @ 문자를 포함할 수 없습니다."
            case .invalidEmail:
                return "이메일은 유효한 형식이어야 합니다. (예: user@example.com)"
            case .invalidPassword:
                return "비밀번호는 최소 8자 이상이며, 영문자, 숫자, 특수문자(@$!%*#?&)를 각각 1개 이상 포함해야 합니다."
            }
        }
    }
}
