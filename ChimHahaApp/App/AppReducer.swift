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
    }
    
    enum Action {
        case tabSelected(Tab)
        case home(HomeReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none
            case .home:
                return .none
            }
        }
    }
}
