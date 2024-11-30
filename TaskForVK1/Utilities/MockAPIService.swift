//
//  MockAPIService.swift
//  TaskForVK1
//
//  Created by Bema on 30/11/24.
//

import Foundation

class MockAPIService: APIService {
    var mockRepositories: [Repository]?
    var mockError: Error?
    
    override func fetchRepositories(page: Int) async throws -> [Repository] {
        if let error = mockError {
            throw error
        }
        return mockRepositories ?? []
    }
}
