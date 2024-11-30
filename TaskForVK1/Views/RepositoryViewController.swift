//
//  ViewController.swift
//  TaskForVK1
//
//  Created by Bema on 30/11/24.
//

import UIKit

class RepositoryViewController: UIViewController {
    private var viewModel = RepositoryViewModel()
    private var tableView: UITableView!
    private var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupRefreshControl()
        bindViewModel()
        viewModel.fetchRepositories()
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: "RepositoryCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        view.addSubview(tableView)
    }

    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func bindViewModel() {
        viewModel.$repositories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &viewModel.cancellables)
    }

    @objc private func refreshList() {
        viewModel.repositories.removeAll()
        viewModel.fetchRepositories()
        refreshControl.endRefreshing()
    }
}

extension RepositoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! RepositoryCell
        let repository = viewModel.repositories[indexPath.row]
        cell.configure(with: repository)

        if indexPath.row == viewModel.repositories.count - 1 && !viewModel.isLoading {
            viewModel.fetchRepositories()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = viewModel.repositories[indexPath.row]
        viewModel.deleteRepository(at: indexPath.row)
    }
}


