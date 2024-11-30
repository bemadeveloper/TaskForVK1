//
//  MockURLSession.swift
//  TaskForVK1
//
//  Created by Bema on 30/11/24.
//

import Foundation
import XCTest
@testable import TaskForVK1

class MockURLSession: URLSession {
    var data: Data?
    var error: Error?
    
    override func data(from: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        guard let data = data else {
            throw URLError(.badServerResponse)
        }
        return (data, URLResponse())
    }
}
