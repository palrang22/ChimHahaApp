//
//  HomeReducer.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/3/26.
//

import Foundation

import ComposableArchitecture


@Reducer
struct HomeReducer {
    
    @ObservableState
    struct State: Equatable {
        var posts: [Post] = []
        var isLoading = false
        var errorMessage: String? = nil
        var selectedBoard: Board = .popular
        var filter: FeedFilter = .all
        
        var drawer: BoardDrawerReducer.State  = .init()
    }
    
    enum Action {
        case onAppear
        case postResponse(Result<[Post], any Error>)
        case postTapped(Post)
        case filterChanged(FeedFilter)
        case boardChanged(Board)
        
        case drawer(BoardDrawerReducer.Action)
    }
    
    @Dependency(\.postRepository) var postRepository
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    do {
                        let posts = try await postRepository.fetchPosts()
                        await send(.postResponse(.success(posts)))
                    } catch {
                        await send(.postResponse(.failure(error)))
                    }
                }
                
            case let .postResponse(.success(posts)):
                state.isLoading = false
                state.posts = posts
                return .none
                
            case let .postResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case .postTapped:
                return .none
                
            case let .filterChanged(filter):
                state.filter = filter
                return .none
                
            case let .boardChanged(board):
                state.selectedBoard = board
                return .none
                
                
            case let .drawer(.boardSelected(board)):
                state.selectedBoard = board
                return .none
                
            case .drawer:
                return .none
            }
        }
    }
}
