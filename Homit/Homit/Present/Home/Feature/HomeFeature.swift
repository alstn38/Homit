//
//  HomeFeature.swift
//  Homit
//
//  Created by 강민수 on 5/18/25.
//

import Foundation

import ComposableArchitecture

enum EstateCategory: String, CaseIterable, Equatable {
    case oneRoom = "원룸"
    case officetel = "오피스텔"
    case apartment = "아파트"
    case villa = "빌라"
    case storefront = "상가"
    
    var displayName: String {
        return self.rawValue
    }
    
    var imageName: String {
        switch self {
        case .oneRoom: return "oneRoom"
        case .officetel: return "officetel"
        case .apartment: return "apartment"
        case .villa: return "villa"
        case .storefront: return "storefront"
        }
    }
}

@Reducer
struct HomeFeature {
    
    @Dependency(\.estateRepository) var estateRepository
    
    @ObservableState
    struct State: Equatable {
        var searchText: String = ""
        var todayEstates: [EstateEntity] = []
        var recentEstates: [EstateEntity] = []
        var hotEstates: [EstateEntity] = []
        var todayTopics: [TopicEntity] = []
        var advertisements: [AdvertisementEntity] = []
        var isLoading: Bool = false
        var selectedTodayEstateIndex: Int = 0
        
        /// 로드 상태 추가 - 중복 로드 방지
        var hasLoadedInitialData: Bool = false
        
        // 로딩 카운터 추가 - 모든 작업이 완료되면 로딩 해제
        var loadingTasksCount: Int = 0
        
        @Presents
        var alert: AlertState<Action.Alert>?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onAppear
        case searchTextChanged(String)
        
        // Data Loading Actions
        case loadInitialData
        case loadTodayEstates
        case loadRecentEstates
        case loadHotEstates
        case loadTodayTopics
        case loadAdvertisements
        
        // Success Actions
        case todayEstatesLoaded([EstateEntity])
        case recentEstatesLoaded([EstateEntity])
        case hotEstatesLoaded([EstateEntity])
        case todayTopicsLoaded([TopicEntity])
        case advertisementsLoaded([AdvertisementEntity])
        
        // Failure Actions
        case loadingFailed(String)
        
        // UI Actions
        case todayEstatePageChanged(Int)
        case categoryButtonTapped(EstateCategory)
        case estateItemTapped(EstateEntity)
        case topicItemTapped(TopicEntity)
        case viewAllRecentEstatesTapped
        case viewAllHotEstatesTapped
        
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        enum Alert: Equatable {
            case errorAlertDismissed
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .onAppear:
                // 이미 로드했으면 다시 로드하지 않음
                guard !state.hasLoadedInitialData else {
                    return .none
                }
                
                state.hasLoadedInitialData = true
                return .send(.loadInitialData)
                
            case .loadInitialData:
                state.isLoading = true
                state.loadingTasksCount = 5  // 5개의 로딩 작업
                
                return .merge(
                    .send(.loadTodayEstates),
                    .send(.loadRecentEstates),
                    .send(.loadTodayTopics),
                    .send(.loadAdvertisements)
                )
                
            case .searchTextChanged(let text):
                state.searchText = text
                return .none
                
            case .loadTodayEstates:
                return .run { send in
                    do {
                        let estates = try await estateRepository.getTodayEstates()
                        await send(.todayEstatesLoaded(estates))
                    } catch {
                        await send(.loadingFailed("오늘의 매물을 불러오는데 실패했습니다: \(error.localizedDescription)"))
                    }
                    await send(.loadHotEstates)
                }
                
            case .loadRecentEstates:
                return .run { send in
                    let estates = estateRepository.getRecentEstates(limit: 10)
                    await send(.recentEstatesLoaded(estates))
                }
                
            case .loadHotEstates:
                return .run { send in
                    do {
                        let estates = try await estateRepository.getHotEstates()
                        await send(.hotEstatesLoaded(estates))
                    } catch {
                        await send(.loadingFailed("HOT 매물을 불러오는데 실패했습니다: \(error.localizedDescription)"))
                    }
                }
                
            case .loadTodayTopics:
                return .run { send in
                    do {
                        let topics = try await estateRepository.getTodayTopics()
                        await send(.todayTopicsLoaded(topics))
                    } catch {
                        await send(.loadingFailed("오늘의 토픽을 불러오는데 실패했습니다: \(error.localizedDescription)"))
                    }
                }
                
            case .loadAdvertisements:
                return .run { send in
                    // Mock 광고 데이터 로드
                    let mockAds = [
                        AdvertisementEntity(title: "신혼집에는 새 설렘을!", content: "특별한 신혼집을 찾아보세요"),
                        AdvertisementEntity(title: "내일 보여하는 감성소품!", content: "집을 더욱 아름답게 꾸며보세요")
                    ]
                    await send(.advertisementsLoaded(mockAds))
                }
                
            case .todayEstatesLoaded(let estates):
                state.todayEstates = estates
                state.loadingTasksCount -= 1
                
                if state.loadingTasksCount <= 0 {
                    state.isLoading = false
                }
                return .none
                
            case .recentEstatesLoaded(let estates):
                state.recentEstates = estates
                state.loadingTasksCount -= 1
                
                if state.loadingTasksCount <= 0 {
                    state.isLoading = false
                }
                return .none
                
            case .hotEstatesLoaded(let estates):
                state.hotEstates = estates
                state.loadingTasksCount -= 1
                
                if state.loadingTasksCount <= 0 {
                    state.isLoading = false
                }
                return .none
                
            case .todayTopicsLoaded(let topics):
                state.todayTopics = topics
                state.loadingTasksCount -= 1
                
                if state.loadingTasksCount <= 0 {
                    state.isLoading = false
                }
                return .none
                
            case .advertisementsLoaded(let advertisements):
                state.advertisements = advertisements
                state.loadingTasksCount -= 1
                
                if state.loadingTasksCount <= 0 {
                    state.isLoading = false
                }
                return .none
                
            case .loadingFailed(let errorMessage):
                state.loadingTasksCount -= 1
                
                if state.loadingTasksCount <= 0 {
                    state.isLoading = false
                }
                
                state.alert = AlertState(
                    title: { TextState("오류") },
                    actions: {
                        ButtonState(action: .errorAlertDismissed) {
                            TextState("확인")
                        }
                    },
                    message: { TextState(errorMessage) }
                )
                return .none
                
            case .todayEstatePageChanged(let index):
                state.selectedTodayEstateIndex = index
                return .none
                
            case .categoryButtonTapped(let category):
                // TODO: 카테고리별 필터링 구현
                return .none
                
            case .estateItemTapped(let estate):
                // 최근 본 매물에 저장
                return .run { send in
                    do {
                        try estateRepository.saveRecentEstate(estate)
                        await send(.loadRecentEstates)
                    } catch {
                        // 에러 처리는 선택사항 - 저장 실패해도 앱 진행에는 문제없음
                        print("최근 본 매물 저장 실패: \(error)")
                    }
                }
                
            case .topicItemTapped(let topic):
                // TODO: 토픽 상세 화면으로 이동
                return .none
                
            case .viewAllRecentEstatesTapped:
                // TODO: 최근 본 매물 전체 목록으로 이동
                return .none
                
            case .viewAllHotEstatesTapped:
                // TODO: HOT 매물 전체 목록으로 이동
                return .none
                
            case .alert(.presented(.errorAlertDismissed)):
                return .none
                
            case .alert(.dismiss):
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
