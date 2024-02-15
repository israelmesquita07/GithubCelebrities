//
//  GithubCelebritiesModels.swift
//  Github Celebrities
//
//  Created by Israel on 18/02/20.
//  Copyright (c) 2020 israel3D. All rights reserved.
//

import UIKit

enum GithubCelebrities {
    // MARK: Use cases
    enum Users {
        struct Request {
            var page = 0
        }
        
        struct Response {
            var usersCelebrities: UsersCelebrities?
        }
        
        struct ViewModel {
            var usersCelebrities: UsersCelebrities?
        }
    }
}
