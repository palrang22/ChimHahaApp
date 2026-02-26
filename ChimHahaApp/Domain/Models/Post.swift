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
