//
//  Post.swift
//  ChimHahaApp
//
//  Created by 김승희 on 2/26/26.
//

import Foundation

struct Post: Equatable, Identifiable {
    let id: String
    let userId: String
    let name: String
    let title: String
    let body: String
    let imageURL: URL?
    let tags: [String]?
    let viewCount: Int?
    let likeCount: Int?
    let dislikeCount: Int?
    let commentCount: Int?
    let scrapCount: Int?
    let createdAt: String?
}


extension Post: Decodable {
    private struct Reactions: Decodable {
        let likes: Int
        let dislikes: Int
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, userId, title, body, tags, views, reactions
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let rawId = try c.decode(Int.self, forKey: .id)
        id = String(rawId)
        userId = try String(c.decode(Int.self, forKey: .userId))
        title = try c.decode(String.self, forKey: .title)
        body = try c.decode(String.self, forKey: .body)
        tags = try c.decodeIfPresent([String].self, forKey: .tags)
        viewCount = try c.decodeIfPresent(Int.self, forKey: .views)
        
        let reactions = try c.decodeIfPresent(Reactions.self, forKey: .reactions)
        likeCount = reactions?.likes
        dislikeCount = reactions?.dislikes
        
        // Fake fields — 실제 API 교체 시 여기만 수정
        name = "User \(userId)"
        imageURL = rawId % 3 == 0 ? nil : URL(string: "https://picsum.photos/seed/\(rawId)/400/300")
        let hours = rawId % 48
        createdAt = hours == 0 ? "방금 전" : "\(hours)시간 전"
        commentCount = nil
        scrapCount = nil
    }
}
