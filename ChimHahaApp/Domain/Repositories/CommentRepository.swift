//
//  CommentRepository.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/3/26.
//

protocol CommentRepository: Sendable {
    func fetchComments(postId: String) async throws -> [Comment]
}
