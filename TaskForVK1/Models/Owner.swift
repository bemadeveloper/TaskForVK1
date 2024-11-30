//
//  Owner.swift
//  TaskForVK1
//
//  Created by Bema on 30/11/24.
//

import Foundation

struct Owner: Codable {
    let avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
