//
//  FeedFilter.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/3/26.
//

enum FeedFilter: String, CaseIterable, Equatable {
    case all = "전체"
    case popular = "인기"
    case weekly = "주간"
    case monthly = "월간"
}
