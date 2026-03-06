//
//  BoardDrawerReducer.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/4/26.
//

import ComposableArchitecture


@Reducer
struct BoardDrawerReducer {
    
    @ObservableState
    struct State: Equatable {
        var isOpen: Bool = false
        var expandedSections: Set<Board.Section> = []
        var favorites: [String] = []
    }
    
    enum Action {
        case open
        case close
        case toggleSection(Board.Section)
        case toggleFavorite(String)
        case boardSelected(Board)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .open:
                state.isOpen = true
                return .none
                
            case .close:
                state.isOpen = false
                return .none
                
            case let .toggleSection(section):
                if state.expandedSections.contains(section) {
                    state.expandedSections.remove(section)
                } else {
                    state.expandedSections.insert(section)
                }
                return .none
                
            case let .toggleFavorite(boardID):
                if state.favorites.contains(boardID) {
                    state.favorites.removeAll { $0 == boardID }
                } else {
                    state.favorites.append(boardID)
                }
                return .none
                
            case .boardSelected:
                state.isOpen = false
                return .none
            }
        }
    }
}
