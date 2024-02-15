//
//  API.swift
//  Github Celebrities
//
//  Created by Israel on 18/02/20.
//  Copyright © 2020 israel3D. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case invalidURL
    case responseError
    case noData
    case parseData
}

protocol Networking {
    func fetchData<T: Decodable>(_ request: GithubCelebrities.Users.Request, completion: @escaping (Result<T, NetworkingError>) -> Void)
}

final class NetworkingAPI: Networking {
    let session: URLSession
    let urlString: String

    init(urlString: String,
         session: URLSession = URLSession.shared) {
        self.urlString = urlString
        self.session = session
    }

    func fetchData<T: Decodable>(_ request: GithubCelebrities.Users.Request, completion: @escaping (Result<T, NetworkingError>) -> Void) {
        guard let cfUrl = CFURLCreateWithString(nil, "\(urlString)\(request.page)" as CFString, nil),
              let url = cfUrl as URL? else {
            completion(.failure(.invalidURL))
            return
        }
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.responseError))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            guard let users = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.parseData))
                return
            }
            completion(.success(users))
            
        }
        task.resume()
    }
}
