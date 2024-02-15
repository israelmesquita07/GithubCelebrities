//
//  GithubCelebritiesPresenter.swift
//  Github Celebrities
//
//  Created by Israel on 18/02/20.
//  Copyright (c) 2020 israel3D. All rights reserved.
//

import UIKit

protocol GithubCelebritiesPresentationLogic {
    func presentUsers(response: GithubCelebrities.Users.Response)
    func presentError()
    func toggleLoading(_ bool: Bool)
}

final class GithubCelebritiesPresenter: GithubCelebritiesPresentationLogic {
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
