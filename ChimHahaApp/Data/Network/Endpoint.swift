//
//  Endpoint.swift
//  ChimHahaApp
//
//  Created by 김승희 on 2/26/26.
//

import Foundation


enum Endpoint {
    case posts
    case post(id: String)
    case comments(postId: String)
    case users
    case user(id: String)
    
    private static let baseURL = "https://dummyjson.com"
    
    var url: URL? {
        switch self {
        case .posts: URL(string: "\(Self.baseURL)/posts")
        case .post(let id): URL(string: "\(Self.baseURL)/posts/\(id)")
        case .comments(let id): URL(string: "\(Self.baseURL)/posts/\(id)/comments")
        case .users: URL(string: "\(Self.baseURL)/users")
        case .user(let id): URL(string: "\(Self.baseURL)/users/\(id)")
        }
    }
}
