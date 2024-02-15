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
}

struct User: Decodable {
    let id: Int?
    let name: String?
    let stargazersCount: Int?
    let owner: Owner?
}

struct Owner: Decodable {
    let login: String?
    let avatarUrl: String?
}
