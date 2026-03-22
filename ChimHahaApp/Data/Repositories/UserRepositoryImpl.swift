//
//  UserRepositoryImpl.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/22/26.
//

final class UserRepositoryImpl: UserRepository {
    private let client: APIClient
    
    init(client: APIClient = APIClient()) {
        self.client = client
    }
    
    func fetchUser(id: String) async throws -> User {
        try await client.fetch(.user(id: id))
    }
}
