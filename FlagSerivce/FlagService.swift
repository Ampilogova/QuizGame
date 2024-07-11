//
//  FlagService.swift
//  FlagsQuizGame
//
//  Created by Tatiana Ampilogova on 7/11/24.
//

import Foundation

protocol FlagService {
    func sendRequest() async throws -> [Country]
}

class FlagServiceImpl: FlagService {
    
    private let stringURL = "https://cdn.jsdelivr.net/npm/country-flag-emoji-json@2.0.0/dist/index.json"
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func sendRequest() async throws -> [Country] {
        guard let url = URL(string: stringURL) else {
            return []
        }
        let urlRequest = URLRequest(url: url)
        let request = NetworkRequest(url: urlRequest)
        let data = try await networkService.send(request: request)
        let decoder = JSONDecoder()
        let countries =  try decoder.decode([Country].self, from: data)
        return countries
    }
}
