//
//  PostRepositoryDependency.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/3/26.
//

import ComposableArchitecture


private enum PostRepositoryKey: DependencyKey {
    static let liveValue: PostRepository = PostRepositoryImpl()
}

private enum CommentRepositoryKey: DependencyKey {
    static let liveValue: CommentRepository = CommentRepositoryImpl()
}

private enum UserRepositoryKey: DependencyKey {
    static let liveValue: UserRepository = UserRepositoryImpl()
}


extension DependencyValues {
    var postRepository: PostRepository {
        get { self[PostRepositoryKey.self] }
        set { self[PostRepositoryKey.self] = newValue }
    }
    
    var commentRepository: CommentRepository {
        get { self[CommentRepositoryKey.self] }
        set { self[CommentRepositoryKey.self] = newValue }
    }
    
    var userRepository: UserRepository {
        get { self[UserRepositoryKey.self] }
        set { self[UserRepositoryKey.self] = newValue}
    }
}
