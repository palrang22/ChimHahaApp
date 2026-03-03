//
//  Comment.swift
//  ChimHahaApp
//
//  Created by 김승희 on 2/26/26.
//

import Foundation


struct Comment: Equatable, Identifiable {
    let id: String
    let parentId: String?
    let postId: String
    let userId: String
    let name: String
    let body: String
    let likeCount: Int?
    let createdAt: String?
}

extension Comment: Decodable {
    private struct CommentUser: Decodable {
        let id: Int
        let fullName: String
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, postId, body, likes, user
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let rawId = try c.decode(Int.self, forKey: .id)
        id = String(rawId)
        postId = try String(c.decode(Int.self, forKey: .postId))
        
        let user = try c.decode(CommentUser.self, forKey: .user)
        userId = String(user.id)
        name = user.fullName
        
        body = try c.decode(String.self, forKey: .body)
        likeCount = try c.decodeIfPresent(Int.self, forKey: .likes)
        
        // TODO: Fake fields - 추후수정
        parentId = nil
        let hours = rawId % 24
        createdAt = hours == 0 ? "방금 전" : "\(hours)시간 전"
    }
}
