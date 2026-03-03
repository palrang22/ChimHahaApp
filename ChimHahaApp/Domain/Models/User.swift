//
//  User.swift
//  ChimHahaApp
//
//  Created by 김승희 on 2/26/26.
//

import Foundation


struct User: Codable, Equatable, Identifiable {
    let id: String
    let name: String
    let email: String
    let imageURL: String?
    let point: Int
}
