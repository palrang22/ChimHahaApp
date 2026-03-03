//
//  PostRepository.swift
//  ChimHahaApp
//
//  Created by 김승희 on 2/26/26.
//

protocol PostRepository: Sendable {
    func fetchPosts() async throws -> [Post]
    func fetchPost(id: String) async throws -> Post
    func fetchComments(postId: String) async throws -> [Comment]
}
