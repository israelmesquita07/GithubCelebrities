//
//  API.swift
//  Github Celebrities
//
//  Created by Israel on 18/02/20.
//  Copyright © 2020 israel3D. All rights reserved.
//

import Foundation

//class API {
//    
//    static func getUsers(_ request: GithubCelebrities.Users.Request, onComplete:@escaping(Result<UsersCelebrities,Error>) -> Void) {
//        if let url = URL(string: "\(Endpoints.urlPage)\(request.page)") {
//            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if error == nil {
//                    guard let data = data else { return }
//                    if let dictJson = self.parseDataToDictionary(data) {
//                        if let model = try? JSONDecoder().decode(UsersCelebrities.self, from: JSONSerialization.data(withJSONObject: dictJson, options: .prettyPrinted)) {
//                            onComplete(.success(model))
//                        }
//                    }
//                } else {
//                    onComplete(.failure(error!))
//                }
//            }
//            dataTask.resume()
//        }
//    }
//    
//    private static func parseDataToDictionary(_ data:Data) -> [String: Any]? {
//        
//        if let dictJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
//            return dictJson
//        }
//        return nil
//    }
//}

enum NetworkingError: Error {
    case invalidURL
    case responseError
    case noData
    case parseData
}

protocol Networking {
    func getUsers(_ request: GithubCelebrities.Users.Request, completion: @escaping (Result<UsersCelebrities,NetworkingError>) -> Void)
}

final class NetworkingAPI: Networking {
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func getUsers(_ request: GithubCelebrities.Users.Request, completion: @escaping (Result<UsersCelebrities, NetworkingError>) -> Void) {
        guard let url = URL(string: "\(Endpoints.urlPage)\(request.page)") else {
            completion(.failure(.invalidURL))
            return
        }
        let task = session.dataTask(with: url) { data, response, error in
            guard error != nil else {
                completion(.failure(.responseError))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            guard let users = try? JSONDecoder().decode(UsersCelebrities.self, from: data) else {
                completion(.failure(.parseData))
                return
            }
            completion(.success(users))
            
        }
        task.resume()
    }
}
