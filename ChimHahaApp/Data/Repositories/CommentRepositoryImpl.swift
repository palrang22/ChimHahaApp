//
//  CommentRepositoryImpl.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/3/26.
//

final class CommentRepositoryImpl: CommentRepository {
    private let client: APIClient
    
    init(client: APIClient = APIClient()) {
        self.client = client
    }
    
    func fetchComments(postId: String) async throws -> [Comment] {
        struct Response: Decodable { let comments: [Comment] }
        let response: Response = try await client.fetch(.comments(postId: postId))
        return response.comments
    }
}
