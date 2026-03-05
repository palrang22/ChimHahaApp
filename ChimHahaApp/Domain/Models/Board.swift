//
//  Board.swift
//  ChimHahaApp
//
//  Created by 김승희 on 2/26/26.
//

import Foundation


struct Board: Equatable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let emoji: String
    let viewType: ViewType
    let section: Section?
    
    enum ViewType {
        case list, grid, wish
    }
    
    enum Section: String, CaseIterable {
        case chimchakman, independent, guzzu, administrative
    }
}

extension Board {
    static let popular = Board(
        id: "popular",
        name: "인기글",
        description: "추천 많이 받으면 올라갑니다.",
        emoji: "🔥",
        viewType: .list,
        section: nil
    )
    
    static let alexandria = Board(
        id: "alexandria",
        name: "알렉산드리아 짤 도서관",
        description: "유저가 올리고 침착맨이 직접 선정하는 알렉산드리아 짤 도서관",
        emoji: "🏛️",
        viewType: .grid,
        section: nil
    )
    
    static let museum = Board(
        id: "museum",
        name: "침하하 박물관",
        description: nil,
        emoji: "🖼️",
        viewType: .list,
        section: nil
    )
    
    static let all = Board(
        id: "all",
        name: "전체글",
        description: nil,
        emoji: "📋",
        viewType: .list,
        section: nil
    )
    
    // MARK: - .chimchakman
    static let notice = Board(
        id: "notice",
        name: "방송일정 및 공지",
        description: "방송 일정과 공지를 안내하는 게시판입니다.",
        emoji: "👀",
        viewType: .list,
        section: .chimchakman
    )
    
    static let chimchakman = Board(
        id: "chimchakman",
        name: "침착맨",
        description: "침착맨에 대해 이야기하는 게시판입니다.",
        emoji: "😊",
        viewType: .list,
        section: .chimchakman
    )
    
    static let chimJjal = Board(
        id: "chimjjal",
        name: "침착맨 짤",
        description: "침착맨의 움짤이나 안움짤을 올려주세요.",
        emoji: "🎃",
        viewType: .list,
        section: .chimchakman
    )
    
    static let fanart = Board(
        id: "fanart",
        name: "침착맨 팬아트",
        description: "침착맨을 소재로 한 창작물을 올려주세요.",
        emoji: "🎨",
        viewType: .list,
        section: .chimchakman
    )
    
    static let chimGame = Board(
        id: "chimgame",
        name: "침겜카 게시판",
        description: "침착맨 포토게임카드 관련 이야기를 나눕니다. 팝업 시즌이 되면, 팝업 게시판으로 변동됩니다.",
        emoji: "🚩",
        viewType: .list,
        section: .chimchakman
    )
    
    static let request = Board(
        id: "request",
        name: "방송 해줘요",
        description: "침착맨이 했으면 하는 것들을 추천해 주세요.",
        emoji: "📣",
        viewType: .list,
        section: .chimchakman
    )
    
    static let recommend = Board(
        id: "recommend",
        name: "추천 침투부 & 찾아요",
        description: "가물가물한 내용 집단지성으로 찾고, 재밌게 본 영상 공유하기",
        emoji: "🍳",
        viewType: .list,
        section: .chimchakman
    )
    
    static let drawing = Board(
        id: "drawing",
        name: "침착맨의 그림",
        description: "침착맨의 그림을 모은 게시판입니다.",
        emoji: "🎪",
        viewType: .list,
        section: .chimchakman
    )
    
    // MARK: - .independent
    static let humor = Board(
        id: "humor",
        name: "유머",
        description: "웃긴 걸 올려주세요. 유저 추천으로 침하하로 옮겨지는 게시판입니다.",
        emoji: "😄",
        viewType: .list,
        section: .independent
    )
    
    static let exaggeration = Board(
        id: "exaggeration",
        name: "호들갑",
        description: "호들갑을 떨어주세요.",
        emoji: "😱",
        viewType: .list,
        section: .independent
    )
    
    static let hobby = Board(
        id: "hobby",
        name: "취미",
        description: "회원들끼리 다양한 주제의 취미를 공유하는 게시판입니다.",
        emoji: "📖",
        viewType: .list,
        section: .independent
    )
    
    static let internet = Board(
        id: "internet",
        name: "인터넷방송",
        description: "인터넷 방송에 관한 이야기를 나누는 게시판입니다.",
        emoji: "💻",
        viewType: .list,
        section: .independent
    )
    
    static let daily = Board(
        id: "daily",
        name: "일상",
        description: "일상 잡담하는 게시판입니다.",
        emoji: "😎",
        viewType: .list,
        section: .independent
    )
    
    // MARK: - .guzzu
//    static let guzzu = Board(
//        id: "guzzu",
//        name: "ㅊㅊㅁ 구쭈",
//        description: "구쭈 관련 소식을 공유합니다.",
//        emoji: "🎉",
//        viewType: .list,
//        section: .guzzu
//    )
//    
//    static let shop = Board(
//        id: "shop",
//        name: "얼렁뚱땅 상점",
//        description: "상점 관련 정보와 이야기를 나눕니다.",
//        emoji: "🐸",
//        viewType: .list,
//        section: .guzzu
//    ) -> 이 두개는 웹사이트로 바로 이동됨
    
    static let review = Board(
        id: "review",
        name: "구쭈 후기",
        description: "침착맨 구쭈를 사고 리뷰를 하는 게시판입니다.",
        emoji: "📸",
        viewType: .list,
        section: .guzzu
    )
    
    // MARK: - .administrative
    static let album = Board(
        id: "album",
        name: "사진첩",
        description: "금병영 관계자의 사진첩! 다양한 비하인드가 올라옵니다.",
        emoji: "🖼️",
        viewType: .list,
        section: .administrative
    )
    
    static let support = Board(
        id: "support",
        name: "침투부 지원하기",
        description: "침투부의 각종 포지션에 지원하세요!",
        emoji: "🙏",
        viewType: .list,
        section: .administrative
    )
    
    static let doodle = Board(
        id: "doodle",
        name: "침하하 두들",
        description: nil,
        emoji: "🤡",
        viewType: .list,
        section: .administrative
    )
    
    static let report = Board(
        id: "report",
        name: "신고/건의",
        description: "불량 유저 및 게시글을 신고하거나 사이트 개선을 위한 건의를 하는 게시판입니다.",
        emoji: "🚨",
        viewType: .list,
        section: .administrative
    )
    
    // MARK: - section: nil
    static let event = Board(
        id: "event",
        name: "이벤트",
        description: nil,
        emoji: "👑",
        viewType: .list,
        section: nil
    )
    
    static let wishStone = Board(
        id: "wishstone",
        name: "소원의 돌",
        description: nil,
        emoji: "🪨",
        viewType: .wish,
        section: nil
    )
    
    static let shortcuts: [Board] = [popular, alexandria, museum, all]

    static let allBoards: [Board] = [
        // Top (section: nil)
        popular,
        alexandria,
        museum,
        all,

        // .chimchakman
        notice,
        chimchakman,
        chimJjal,
        fanart,
        chimGame,
        request,
        recommend,
        drawing,

        // .independent
        humor,
        exaggeration,
        hobby,
        internet,
        daily,

        // .guzzu
//        guzzu,
//        shop,
        review,

        // .administrative
        album,
        support,
        doodle,
        report,

        // section: nil (하단)
        event,
        wishStone
    ]

    static func boards(for section: Section) -> [Board] {
        allBoards.filter { $0.section == section }
    }
}


extension Board.Section {
    var displayName: String {
        switch self {
        case .chimchakman: return "침착맨"
        case .independent: return "독립 게시판"
        case .guzzu: return "구쭈"
        case .administrative: return "행정실"
        }
    }
}
