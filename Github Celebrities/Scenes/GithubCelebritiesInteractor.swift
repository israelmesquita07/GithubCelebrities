//
//  GithubCelebritiesInteractor.swift
//  Github Celebrities
//
//  Created by Israel on 18/02/20.
//  Copyright (c) 2020 israel3D. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates and
//  edited by Israel Mesquita.
//  So you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol GithubCelebritiesBusinessLogic {
    func getUsers(request: GithubCelebrities.Users.Request)
}

class GithubCelebritiesInteractor: GithubCelebritiesBusinessLogic {
    
    var presenter: GithubCelebritiesPresentationLogic?
    
    // MARK: Get Users
    
    func getUsers(request: GithubCelebrities.Users.Request) {
        let worker = GithubCelebritiesWorker()
        worker.getUsers(request) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let usersCelebrities):
                var response = GithubCelebrities.Users.Response()
                response.usersCelebrities = usersCelebrities
                self.presenter?.presentUsers(response: response)
                self.presenter?.toggleLoading(false)
                break
            case .failure(let error):
                print(error.localizedDescription)
                self.presenter?.presentError()
                self.presenter?.toggleLoading(false)
                break
            }
        }
    }
}
