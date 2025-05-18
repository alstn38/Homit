//
//  TabBarView.swift
//  Homit
//
//  Created by 강민수 on 5/18/25.
//

import SwiftUI

import ComposableArchitecture

struct TabBarView: View {
    
    @Perception.Bindable
    var store: StoreOf<TabBarFeature>
    
    var body: some View {
        WithPerceptionTracking {
            TabView(selection: $store.selectedTab) {
                HomeView(store: store.scope(state: \.homeState, action: \.home))
                    .tabItem {
                        Label("홈", image: "homeEmpty")
                    }
                    .tag(TabBarFeature.Tab.home)
                
                FavoriteView(store: store.scope(state: \.favoriteState, action: \.favorite))
                    .tabItem {
                        Label("관심매물", image: "interestEmpty")
                    }
                    .tag(TabBarFeature.Tab.favorite)
                
                SettingView(store: store.scope(state: \.settingState, action: \.setting))
                    .tabItem {
                        Label("설정", image: "settingEmpty")
                    }
                    .tag(TabBarFeature.Tab.setting)
            }
            .accentColor(Color.gray90)
        }
    }
}
