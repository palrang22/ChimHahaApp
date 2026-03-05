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
        struct Response: Decodable { let posts: [Post] }
        let response: Response = try await client.fetch(.posts)
        return response.posts
    }

    func fetchPost(id: String) async throws -> Post {
        try await client.fetch(.post(id: id))
    }
}
