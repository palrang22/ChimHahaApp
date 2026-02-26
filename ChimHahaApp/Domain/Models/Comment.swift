//
//  Comment.swift
//  ChimHahaApp
//
//  Created by 김승희 on 2/26/26.
//

import Foundation


struct Comment: Codable, Equatable, Identifiable {
    let id: String
    let parentId: String?
    let postId: String
    let userId: String
    let name: String
    let body: String
    let likeCount: Int?
    let createdAt: String?
}
