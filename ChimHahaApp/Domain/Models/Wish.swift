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


//TODO: 추후 실제 API와 연결
extension Wish {
    static let dummies: [Wish] = [
        Wish(id: "1", userId: "u1", username: "침투부원", body: "취업하고싶어요", days: 100, streakDays: 30, rank: 1),
        Wish(id: "2", userId: "u2", username: "고양이집사", body: "고양이가 건강하게 해주세요", days: 60, streakDays: 15, rank: 2),
        Wish(id: "3", userId: "u3", username: "뚝딱이", body: "침착맨 건강하세요 화이팅", days: 30, streakDays: 7, rank: 3)
    ]
}
