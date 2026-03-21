//
//  AppReducer.swift
//  ChimHahaApp
//
//  Created by 김승희 on 2/27/26.
//

import ComposableArchitecture

    
@Reducer
struct AppReducer {
    enum Tab: Equatable {
        case home, search, write, myPage
    }
    
    @ObservableState
    struct State: Equatable {
        var selectedTab: Tab = .home
        var home: HomeReducer.State = HomeReducer.State()
        var search: SearchReducer.State = SearchReducer.State()
    }
    
    enum Action {
        case tabSelected(Tab)
        case home(HomeReducer.Action)
        case search(SearchReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeReducer()
        }
        
        Scope(state: \.search, action: \.search) {
            SearchReducer()
        }
        
        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none
            case .home:
                return .none
            case .search:
                return .none
            }
        }
    }
}
