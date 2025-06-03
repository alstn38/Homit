//
//  HomeView.swift
//  Homit
//
//  Created by 강민수 on 5/18/25.
//

import SwiftUI

import ComposableArchitecture

struct HomeView: View {
    
    @Perception.Bindable
    var store: StoreOf<HomeFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationView {
                ScrollView {
                    VStack(spacing: 0) {
                        TodayEstatesSection(
                            estates: store.todayEstates,
                            selectedIndex: $store.selectedTodayEstateIndex,
                            searchText: $store.searchText,
                            onEstateTapped: { estate in
                                store.send(.estateItemTapped(estate))
                            },
                            onPageChanged: { index in
                                store.send(.todayEstatePageChanged(index))
                            }
                        )
                        
                        VStack(spacing: 0) {
                            CategoryButtonsSection { category in
                                store.send(.categoryButtonTapped(category))
                            }
                            RecentEstatesSection(
                                estates: store.recentEstates,
                                onEstateTapped: { estate in
                                    store.send(.estateItemTapped(estate))
                                },
                                onViewAllTapped: {
                                    store.send(.viewAllRecentEstatesTapped)
                                }
                            )
                            HotEstatesSection(
                                estates: store.hotEstates,
                                onEstateTapped: { estate in
                                    store.send(.estateItemTapped(estate))
                                },
                                onViewAllTapped: {
                                    store.send(.viewAllHotEstatesTapped)
                                }
                            )
                            TodayTopicsSection(
                                topics: store.todayTopics,
                                advertisements: store.advertisements,
                                onTopicTapped: { topic in
                                    store.send(.topicItemTapped(topic))
                                }
                            )
                        }
                        .background(Color.gray15)
                    }
                }
                .background(Color.gray15)
                .navigationBarHidden(true)
                .onAppear {
                    store.send(.onAppear)
                }
                .alert($store.scope(state: \.alert, action: \.alert))
                .loadingOverlay(store.isLoading)
            }
        }
    }
}
