//
//  KakaoLoginServiceKey.swift
//  Homit
//
//  Created by 강민수 on 5/28/25.
//

import Foundation

import ComposableArchitecture

private enum KakaoLoginServiceKey: DependencyKey {
    static var liveValue: KakaoLoginService {
        DefaultKakaoLoginService()
    }
}

extension DependencyValues {
    var kakaoLoginService: KakaoLoginService {
        get { self[KakaoLoginServiceKey.self] }
        set { self[KakaoLoginServiceKey.self] = newValue }
    }
}
