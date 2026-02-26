//
//  APIClient.swift
//  ChimHahaApp
//
//  Created by 김승희 on 2/26/26.
//

import Combine
import Foundation


struct APIClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let http = response as? HTTPURLResponse,
                      (200...299).contains(http.statusCode) else {
                    let code = (response as? HTTPURLResponse)?.statusCode ?? -1
                    throw NetworkError.requestFailed(statusCode: code)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if let e = error as? NetworkError { return e }
                if error is DecodingError { return .decodingFailed }
                return .unknown(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
