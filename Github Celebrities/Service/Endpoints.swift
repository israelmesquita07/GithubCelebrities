//
//  Endpoints.swift
//  Github Celebrities
//
//  Created by Israel on 18/02/20.
//  Copyright © 2020 israel3D. All rights reserved.
//

import Foundation

final class Endpoints {
    private static let baseUrl = "https://api.github.com/search/repositories?q=language:swift&sort=stars"
    static let urlPage = "\(Endpoints.baseUrl)&page="
}
