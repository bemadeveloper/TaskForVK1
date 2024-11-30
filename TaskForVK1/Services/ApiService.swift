//
//  ApiService.swift
//  TaskForVK1
//
//  Created by Bema on 30/11/24.
//

import Foundation

class APIService {
    func fetchRepositories(page: Int) async throws -> [Repository] {
        let url = URL(string: "https://api.github.com/search/repositories?q=swift&sort=stars&order=asc&page=\(page)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let response = try JSONDecoder().decode(RepositorySearchResponse.self, from: data)
        
        return response.items
    }
}

