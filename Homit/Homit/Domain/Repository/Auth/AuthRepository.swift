//
//  AuthRepository.swift
//  Homit
//
//  Created by 강민수 on 5/13/25.
//

import Foundation

protocol AuthRepository {
    func signUpWithEmail(email: String, password: String, nickName: String) async throws
}
