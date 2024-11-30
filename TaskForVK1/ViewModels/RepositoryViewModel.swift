//
//  RepositoryViewModel.swift
//  TaskForVK1
//
//  Created by Bema on 30/11/24.
//

import Foundation
import Combine

class RepositoryViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isLoading = false
    private var currentPage = 1
    internal var cancellables: Set<AnyCancellable> = []

    private let apiService = APIService()

    func fetchRepositories() {
        guard !isLoading else { return }

        isLoading = true
        Task {
            do {
                let newRepositories = try await apiService.fetchRepositories(page: currentPage)
                DispatchQueue.main.async {
                    self.repositories.append(contentsOf: newRepositories)
                    self.isLoading = false
                    self.currentPage += 1
                }
            } catch {
                print("Error fetching repositories: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }

    func deleteRepository(at index: Int) {
        repositories.remove(at: index)
    }

    func editRepository(at index: Int, with repository: Repository) {
        repositories[index] = repository
    }
}
