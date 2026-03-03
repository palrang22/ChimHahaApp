//
//  PostRepositoryDependency.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/3/26.
//

import ComposableArchitecture


private enum PostRepositoryKey: DependencyKey {
    static let liveValue: any PostRepository = PostRepositoryImpl()
}


extension DependencyValues {
    var postRepository: any PostRepository {
        get { self[PostRepositoryKey.self] }
        set { self[PostRepositoryKey.self] = newValue }
    }
}
