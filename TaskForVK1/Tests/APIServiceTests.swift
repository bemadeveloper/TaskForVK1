//
//  APIServiceTest.swift
//  TaskForVK1
//
//  Created by Bema on 30/11/24.
//

import Foundation

class APIServiceTests: XCTestCase {
    var apiService: APIService!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        apiService = APIService(session: mockSession) // assuming you've updated your APIService to accept a session parameter
    }

    func testFetchRepositoriesSuccess() async {
        // Arrange: Mock a successful API response with sample data
        let sampleData = """
        {
            "items": [
                {
                    "name": "Repo1",
                    "description": "Test repository",
                    "owner": {
                        "avatar_url": "https://example.com/avatar1.png"
                    }
                }
            ]
        }
        """.data(using: .utf8)
        mockSession.data = sampleData

        // Act: Call the fetchRepositories method
        do {
            let repositories = try await apiService.fetchRepositories(page: 1)
            
            // Assert: Check if the fetched repository is correct
            XCTAssertEqual(repositories.count, 1)
            XCTAssertEqual(repositories.first?.name, "Repo1")
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }

    func testFetchRepositoriesFailure() async {
        // Arrange: Mock a failure with an error
        mockSession.error = URLError(.notConnectedToInternet)

        // Act: Call the fetchRepositories method
        do {
            _ = try await apiService.fetchRepositories(page: 1)
            XCTFail("Expected failure, but the request succeeded.")
        } catch let error as URLError {
            // Assert: Check if the error matches the expected error
            XCTAssertEqual(error.code, .notConnectedToInternet)
        } catch {
            XCTFail("Expected URLError, but got \(error).")
        }
    }
}
