//
//  FavouriteListVC.swift
//  GHFollowers
//
//  Created by flamyoad on 17/02/2024.
//

import UIKit
import RxSwift

class FavouriteListVC: UIViewController {
    private let disposeBag = DisposeBag()

    let tableView = UITableView()
    var favourites: [Follower] = []
    
    var viewModel: FavouriteListViewModel!
    var persistenceManager: PersistenceManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = FavouriteListViewModel(dependencies: ServiceLocator.shared)
        self.persistenceManager = ServiceLocator.shared.getPersistenceManager() // move logic to vm!!!!!!!
        view.backgroundColor = .systemCyan
        setupViewController()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initFavouritesList()
    }
    
    func setupViewController() {
        view.backgroundColor = .systemBackground
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: FavouriteCell.reuseID)
    }
    
    func initFavouritesList() {
        viewModel.retrieveFavourites()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] favourites in
                    guard let self = self else { return }
                    if (favourites.isEmpty) {
                        self.showEmptyStateView(with: "No favourites?\nAdd one of the follower screen", in: self.view)
                    } else {
                        self.favourites = favourites
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                },
                onFailure: { [weak self] error in
                    self?.presentGFAlertOnMainThread(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Ok")
                }
            ).disposed(by: disposeBag)
    }
}

extension FavouriteListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reuseID, for: indexPath) as! FavouriteCell
        let favourite = favourites[indexPath.row]
        cell.set(favourite: favourite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favourite = favourites[indexPath.row]
        let destVC = FollowerListVC(username: favourite.login)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let favourite = favourites[indexPath.row]
    
        persistenceManager.updateWith(favourite: favourite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { 
                favourites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
            
        }
    }
}


