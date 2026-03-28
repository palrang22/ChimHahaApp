//
//  PostDetailReducer.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/12/26.
//

import Foundation

import ComposableArchitecture


@Reducer
struct PostDetailReducer {
    
    @ObservableState
    struct State: Equatable {
        var post: Post
        var comments: [Comment] = []
        var isLoading = false
        var errorMessage: String? = nil
        var commentInput: String = ""
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case commentsResponse(Result<[Comment], any Error>)
        case likeTapped
        case submitComment
    }
    
    @Dependency(\.commentRepository) var commentRepository
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            case .onAppear:
                state.isLoading = true
                let postId = state.post.id
                return .run { send in
                    do {
                        let comments = try await commentRepository.fetchComments(postId: postId)
                        await send(.commentsResponse(.success(comments)))
                    } catch {
                        await send(.commentsResponse(.failure(error)))
                    }
                }
            case let .commentsResponse(.success(comments)):
                state.isLoading = false
                state.comments = comments
                return .none
                
            case let .commentsResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case .likeTapped:
                return .none
            case .submitComment:
                state.commentInput = ""
                return .none
            }
        }
    }
}
