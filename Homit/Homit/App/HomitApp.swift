//
//  HomitApp.swift
//  Homit
//
//  Created by 강민수 on 5/10/25.
//

import SwiftUI

import ComposableArchitecture

@main
struct HomitApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: AppFeature.State()) {
                AppFeature()
            })
        }
    }
}
