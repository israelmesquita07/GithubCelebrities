//
//  UsersCelebrities.swift
//  Github Celebrities
//
//  Created by Israel on 18/02/20.
//  Copyright © 2020 israel3D. All rights reserved.
//

import Foundation

struct UsersCelebrities: Decodable {
    let items: [User]?
    let totalCount:Int?
    
    enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
    }
}

struct User: Decodable {
    let id: Int?
    let name: String?
    let stargazersCount: Int?
    let owner: Owner?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case stargazersCount = "stargazers_count"
        case owner
    }
}

struct Owner: Decodable {
    let login: String?
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
