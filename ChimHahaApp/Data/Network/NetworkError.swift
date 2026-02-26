//
//  NetworkError.swift
//  ChimHahaApp
//
//  Created by 김승희 on 2/26/26.
//

import Foundation


enum NetworkError: Error, Equatable {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed
    case unknown(String)
}
