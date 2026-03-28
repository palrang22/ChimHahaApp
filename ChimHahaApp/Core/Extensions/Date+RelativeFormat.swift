//
//  Date+RelativeFormat.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/19/26.
//

import Foundation


extension Date {
    var relativeFormatted: String {
        let now = Date()
        let diff = now.timeIntervalSince(self)
        
        let minute: TimeInterval = 60
        let hour: TimeInterval = 3600
        let day: TimeInterval = 86400
        let week: TimeInterval = day * 7
        
        if diff < hour {
            let minutes = Int(diff/minute)
            return minutes <= 0 ? "방금 전" : "\(minutes)분 전"
        }
        else if diff < day {
            return "\(Int(diff/hour)) 시간 전"
        }
        else if diff < week {
            return "\(Int(diff/day)) 일 전"
        }
        else {
            let calendar = Calendar.current
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            
            if calendar.component(.year, from: self) == calendar.component(.year, from: .now) {
                formatter.dateFormat = "MM.dd"
            } else {
                formatter.dateFormat = "yyyy.MM.dd"
            }
            return formatter.string(from: self)
        }
    }
}
