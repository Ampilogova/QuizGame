//
//  NetworkService.swift
//  QuizGame
//
//  Created by Tatiana Ampilogova on 7/3/24.
//

import Foundation

 protocol NetworkService {
    func send(request: NetworkRequest) async throws -> Data
}

class NetworkServiceImpl: NetworkService {
    
    let urlSession = URLSession.shared
    
    func send(request: NetworkRequest) async throws -> Data {
//        guard let url = request.url else {
//            throw URLError(.badURL)
//        }
        let url = request.url 
        let (data, _) = try await urlSession.data(for: url)
        return data
    }
}
