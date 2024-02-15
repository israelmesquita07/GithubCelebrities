//
//  GithubCelebritiesWorker.swift
//  Github Celebrities
//
//  Created by Israel on 18/02/20.
//  Copyright (c) 2020 israel3D. All rights reserved.
//

import Foundation

final class GithubCelebritiesWorker {
    private let networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }

    func getUsers(_ request: GithubCelebrities.Users.Request, completion: @escaping (Result<UsersCelebrities, NetworkingError>) -> Void) {
        networking.fetchData(request) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
