//
//  AuthRepository.swift
//  Homit
//
//  Created by 강민수 on 5/13/25.
//

import Foundation

protocol AuthRepository {
    /// 로그인을 한 적이 있는지 확인하는 메서드
    func isAuthenticated() -> Bool
    
    /// 이메일을 통한 회원가입 메서드
    func signUpWithEmail(email: String, password: String, nickName: String) async throws
    
    /// 이메일을 통한 로그인 메서드
    func loginWithEmail(email: String, password: String) async throws
    
    /// 애플을 통한 로그인 메서드
    func loginWithApple(idToken: String, nickName: String) async throws
    
    /// 카카오를 통한 로그인 메서드
    func loginWithKakao() async throws
    
    /// 로그아웃 메서드
    func logout() throws
}
