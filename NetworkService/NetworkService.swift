//
//  NetworkService.swift
//  FlagsQuizGame
//
//  Created by Tatiana Ampilogova on 7/11/24.
//

import Foundation

protocol NetworkService {
   func send(request: NetworkRequest) async throws -> Data
}

class NetworkServiceImpl: NetworkService {
   
   let urlSession = URLSession.shared
   
   func send(request: NetworkRequest) async throws -> Data {
       let url = request.url
       let (data, _) = try await urlSession.data(for: url)
       return data
   }
}
