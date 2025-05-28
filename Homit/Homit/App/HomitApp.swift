//
//  HomitApp.swift
//  Homit
//
//  Created by 강민수 on 5/10/25.
//

import SwiftUI

import ComposableArchitecture
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct HomitApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        KakaoSDK.initSDK(appKey: Secret.kakaoAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: AppFeature.State()) {
                AppFeature()
            })
            .onOpenURL(perform: { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    let _ = AuthController.handleOpenUrl(url: url)
                }
            })
        }
    }
}
