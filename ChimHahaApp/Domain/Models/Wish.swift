//
//  Wish.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/28/26.
//

struct Wish: Equatable, Identifiable, Codable {
    let id: String
    let userId: String
    let username: String
    let body: String
    let days: Int
    let streakDays: Int
    let rank: Int
}
