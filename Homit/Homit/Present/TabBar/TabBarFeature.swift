//
//  TabBarFeature.swift
//  Homit
//
//  Created by 강민수 on 5/18/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct TabBarFeature {
    
    @ObservableState
    struct State {
        var selectedTab: Tab = .home
        var homeState = HomeFeature.State()
        var favoriteState = FavoriteFeature.State()
        var settingState = SettingFeature.State()
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case tabSelected(Tab)
        case home(HomeFeature.Action)
        case favorite(FavoriteFeature.Action)
        case setting(SettingFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .tabSelected(let tab):
                state.selectedTab = tab
                return .none
                
            case .home:
                return .none
                
            case .favorite:
                return .none
                
            case .setting:
                return .none
            }
        }
    }
    
    enum Tab: Hashable {
        case home
        case favorite
        case setting
    }
}
