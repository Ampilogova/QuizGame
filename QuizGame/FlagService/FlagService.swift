//
//  FlagService.swift
//  QuizGame
//
//  Created by Tatiana Ampilogova on 7/3/24.
//

import Foundation

protocol FlagService {
    func sendRequest() async throws -> [Country]
}

class FlagServiceImpl: FlagService {
    
    private let stringURL = "https://restcountries.com/v3.1/all?fields=flags"
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func sendRequest() async throws -> [Country] {
        guard let url = URL(string: stringURL) else {
            return []
        }
        let urlRequest = URLRequest(url: url)
        var request = NetworkRequest(url: urlRequest)
        let data = try await networkService.send(request: request)
        let decoder = JSONDecoder()
        let generateResponse = try decoder.decode(GenerateResponse.self, from: data)
        let countries = [Country()]
        return countries
    }
}
