//
//  AuthStateManager.swift
//  Homit
//
//  Created by 강민수 on 5/31/25.
//

import Foundation

enum AuthState: Equatable {
    case authenticated
    case unauthenticated
}

final class AuthStateManager: ObservableObject {
    
    static let shared = AuthStateManager()
    
    @Published var authState: AuthState = .unauthenticated
    
    private init() {}
    
    func updateAuthState(_ state: AuthState) {
        DispatchQueue.main.async {
            self.authState = state
        }
    }
}
