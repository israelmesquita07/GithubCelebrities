//
//  GithubCelebritiesViewController.swift
//  Github Celebrities
//
//  Created by Israel on 18/02/20.
//  Copyright (c) 2020 israel3D. All rights reserved.
//

import UIKit
import Kingfisher

protocol GithubCelebritiesDisplayLogic: AnyObject {
    func displayUsersCelebrities(viewModel: GithubCelebrities.Users.ViewModel)
    func displayError()
    func toggleLoading(_ bool: Bool)
}

final class GithubCelebritiesViewController: UIViewController {
    var interactor: GithubCelebritiesBusinessLogic?
    var users: [User] = []
    let refreshControl = UIRefreshControl()
    let activityIndicator = UIActivityIndicatorView()
    var page = 0, totalPages = Constants.totalPages
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUsers(page)
    }
    
    // MARK: Setup
    
    private func setup() {
        let interactor = GithubCelebritiesInteractor()
        let presenter = GithubCelebritiesPresenter()
        self.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = self
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.allowsSelection = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Atualizando usuários...")
        refreshControl.addTarget(self, action: #selector(refreshUsers(_:)), for: .valueChanged)
    }
    
    // MARK: Get Users
    
    func getUsers(_ page: Int) {
        toggleLoading(true)
        var request = GithubCelebrities.Users.Request()
        request.page = page
        interactor?.getUsers(request: request)
    }
    
    @objc private func refreshUsers(_ sender: Any) {
        page = 0
        getUsers(page)
    }
    
    // MARK: Animation Loading
    
    private func startLoading() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        activityIndicator.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        activityIndicator.startAnimating()
        
        view.addSubview(activityIndicator)
        view.isUserInteractionEnabled = false
    }
    
    private func stopLoading() {
        refreshControl.endRefreshing()
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    private func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - GithubCelebritiesDisplayLogic
extension GithubCelebritiesViewController: GithubCelebritiesDisplayLogic {
    func displayUsersCelebrities(viewModel: GithubCelebrities.Users.ViewModel) {
        guard let usersCelebrities = viewModel.usersCelebrities?.items else { return }
        users.append(contentsOf: usersCelebrities)
        tableView.reloadData()
        toggleLoading(false)
    }
    
    func displayError() {
        showAlert(title: "Ops!", message: "Ocorreu um erro!")
    }
    
    func toggleLoading(_ bool: Bool) {
        bool ? startLoading() : stopLoading()
    }
}

//MARK: - UITableViewDataSource
extension GithubCelebritiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellIdentifier")
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        
        if let username = user.owner?.login, let countStars = user.stargazersCount {
            cell.detailTextLabel?.text = "\(username) (\(countStars) estrelas)"
        }
        
        if let stringUrl = user.owner?.avatarUrl, let urlImage = URL(string: stringUrl) {
            cell.imageView?.layer.cornerRadius = 10.0
            cell.imageView?.clipsToBounds = true
            cell.imageView?.kf.indicatorType = .activity
            cell.imageView?.kf.setImage(with: urlImage, placeholder: UIImage(named: "iTunesArtwork"))
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension GithubCelebritiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == users.count - 1 {
            page = page > totalPages ? 0 : page + 1
            getUsers(page)
        }
    }
}
