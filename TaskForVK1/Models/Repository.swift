//
//  Repository.swift
//  TaskForVK1
//
//  Created by Bema on 30/11/24.
//

import Foundation

struct Repository: Codable {
    let name: String
    let description: String?
    let owner: Owner
}
