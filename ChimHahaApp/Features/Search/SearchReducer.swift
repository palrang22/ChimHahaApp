//
//  SearchReducer.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/21/26.
//

import Foundation

import ComposableArchitecture


@Reducer
struct SearchReducer {
    @ObservableState
    struct State: Equatable {
        var query: String = ""
        var results: [Post] = []
        var allPosts: [Post] = []
        var selectedBoard: Board? = nil
        var isSearching: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case postsResponse(Result<[Post], any Error>)
        case queryChanged(String)
        case boardFilterChanged(Board?)
        case resultsResponse([Post])
    }
    
    @Dependency(\.postRepository) var postRepository
    
    enum CancelID { case search }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onAppear:
                guard state.allPosts.isEmpty else { return .none }
                state.isSearching = true
                return .run { send in
                    do {
                        let posts = try await postRepository.fetchPosts()
                        await send(.postsResponse(.success(posts)))
                    } catch {
                        await send(.postsResponse(.failure(error)))
                    }
                }
                
            case let .postsResponse(.success(posts)):
                state.isSearching = false
                state.allPosts = posts
                return .none
                
            case .postsResponse(.failure):
                state.isSearching = false
                return .none
                
            case let .queryChanged(query):
                state.query = query
                return .run { [state] send in
                    let filtered = state.allPosts.filter { post in
                        query.isEmpty || post.title.localizedCaseInsensitiveContains(query)
                    }
                    await send(.resultsResponse(filtered))
                }
                .debounce(id: CancelID.search, for: 0.3, scheduler: DispatchQueue.main)
                
            case let .boardFilterChanged(board):
                state.selectedBoard = board
                let query = state.query
                return .run { [state] send in
                    let filtered = state.allPosts.filter { post in
                        let matchesQuery = query.isEmpty || post.title.localizedCaseInsensitiveContains(query)
                        return matchesQuery
                    }
                    await send(.resultsResponse(filtered))
                }
            case let .resultsResponse(posts):
                state.results = posts
                return .none
            }
        }
    }
}
