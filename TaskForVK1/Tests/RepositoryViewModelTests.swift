//
//  RepositoryViewModelTests.swift
//  TaskForVK1
//
//  Created by Bema on 30/11/24.
//

import Foundation
import Combine
@testable import TaskForVK1

class RepositoryViewModelTests: XCTestCase {
    var viewModel: RepositoryViewModel!
    var mockAPIService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = RepositoryViewModel(apiService: mockAPIService)
    }

    func testFetchRepositoriesSuccess() async {
        let sampleRepositories = [Repository(name: "Repo1", description: "Test repository", owner: Owner(avatarUrl: "https://example.com/avatar1.png"))]
        mockAPIService.mockRepositories = sampleRepositories

        await viewModel.fetchRepositories()

        XCTAssertEqual(viewModel.repositories.count, 1)
        XCTAssertEqual(viewModel.repositories.first?.name, "Repo1")
    }

    func testFetchRepositoriesLoadingState() async {
        mockAPIService.mockRepositories = [Repository(name: "Repo1", description: "Test repository", owner: Owner(avatarUrl: "https://example.com/avatar1.png"))]

        let expectation = XCTestExpectation(description: "Loading state should toggle.")
        
        viewModel.$isLoading.sink { isLoading in
            if isLoading == false {
                XCTAssertFalse(self.viewModel.isLoading)
                expectation.fulfill()
            }
        }.store(in: &viewModel.cancellables)
        
        await viewModel.fetchRepositories()

        await wait(for: [expectation], timeout: 1.0)
    }

    func testFetchRepositoriesErrorHandling() async {
        mockAPIService.mockError = URLError(.notConnectedToInternet)

        await viewModel.fetchRepositories()

        XCTAssertTrue(viewModel.repositories.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
}
