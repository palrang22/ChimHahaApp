//
//  PostRepository.swift
//  ChimHahaApp
//
//  Created by 김승희 on 2/26/26.
//

final class PostRepositoryImpl: PostRepository {
    private let client: APIClient

    init(client: APIClient = APIClient()) {
        self.client = client
    }

    func fetchPosts() async throws -> [Post] {
        try await client.fetch(.posts)
    }

    func fetchPost(id: String) async throws -> Post {
        try await client.fetch(.post(id: id))
    }

    func fetchComments(postId: String) async throws -> [Comment] {
        try await client.fetch(.comments(postId: postId))
    }
}
