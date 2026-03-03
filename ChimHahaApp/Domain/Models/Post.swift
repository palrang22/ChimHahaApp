//
//  Post.swift
//  ChimHahaApp
//
//  Created by 김승희 on 2/26/26.
//

import Foundation

struct Post: Codable, Equatable, Identifiable {
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


extension Post {
      enum CodingKeys: String, CodingKey {
          case id, userId, title, body
      }

      init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          id = try String(container.decode(Int.self, forKey: .id))
          userId = try String(container.decode(Int.self, forKey: .userId))
          title = try container.decode(String.self, forKey: .title)
          body = try container.decode(String.self, forKey: .body)
          name = "User \(userId)"
          imageURL = nil
          tags = nil
          viewCount = nil
          likeCount = nil
          dislikeCount = nil
          commentCount = nil
          scrapCount = nil
          createdAt = nil
      }
  }
