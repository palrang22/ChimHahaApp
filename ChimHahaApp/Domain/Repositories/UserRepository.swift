//
//  UserRepository.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/22/26.
//

protocol UserRepository: Sendable {
    func fetchUser(id: String) async throws -> User
}
