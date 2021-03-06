//
//  GithubCelebritiesPresenter.swift
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

protocol GithubCelebritiesPresentationLogic {
    func presentUsers(response: GithubCelebrities.Users.Response)
    func presentError()
    func toggleLoading(_ bool: Bool)
}

class GithubCelebritiesPresenter: GithubCelebritiesPresentationLogic {
    
    weak var viewController: GithubCelebritiesDisplayLogic?
    
    // MARK: Present Users
    
    func presentUsers(response: GithubCelebrities.Users.Response) {
        var viewModel = GithubCelebrities.Users.ViewModel()
        viewModel.usersCelebrities = response.usersCelebrities
        viewController?.displayUsersCelebrities(viewModel: viewModel)
    }
    
    func presentError() {
        viewController?.displayError()
    }
    
    func toggleLoading(_ bool: Bool) {
        viewController?.toggleLoading(bool)
    }
}
