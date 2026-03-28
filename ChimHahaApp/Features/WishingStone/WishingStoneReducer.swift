//
//  WishingStoneReducer.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/28/26.
//

import Foundation

import ComposableArchitecture


@Reducer
struct WishingStoneReducer {
    
    @ObservableState
    struct State: Equatable {
        var wishes: [Wish] = []
        var inputText: String = ""
        var todayPrayed: Bool = false
        var isLoading: Bool = false
        var errorMessage: String? = nil
    }
    
    enum Action {
        case onAppear
        case inputChanged(String)
        case submitWish
        case wishesResponse(Result<[Wish], any Error>)
    }
    
    //TODO: 실제 API 연결 전까지 더미데이터 사용
    // @Dependency(\.wishingStoneRepository) var wishingStoneRepository
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                //TODO: 실제 API 연결 전까지 더미데이터 사용
                    let dummies = Wish.dummies
                    await send(.wishesResponse(.success(dummies)))
                }
            case let .inputChanged(text):
                state.inputText = text
                return .none
                
            case .submitWish:
                guard !state.inputText.trimmingCharacters(in: .whitespaces).isEmpty else {
                    return .none
                }
                state.todayPrayed = true
                state.inputText = ""
                return .none
                
            case let .wishesResponse(.success(wishes)):
                state.isLoading = false
                state.wishes = wishes
                return .none
                
            case let .wishesResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            }
        }
    }
}
