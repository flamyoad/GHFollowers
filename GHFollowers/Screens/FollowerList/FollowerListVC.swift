//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by flamyoad on 17/02/2024.
//

import UIKit
import RxSwift

class FollowerListVC: UIViewController {
    
    enum Section {
        case main
    }

    private var networkManager: NetworkManager! // REMOVE
    private let disposeBag = DisposeBag()
    private var viewModel: FollowerListViewModel!
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        self.title = username
        self.viewModel = FollowerListViewModel(dependencies: ServiceLocator.shared)
        self.networkManager = ServiceLocator.shared.getNetworkManager()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupSearchController()
        setupCollectionView()
        getFollowers(username: username, page: page)
        setupDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.setupThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func setupSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        
//        searchController.obscuresBackgroundDuringPresentation = true
        navigationItem.searchController = searchController

        // If set to true, searchbar doesn't show until user starts scrolling
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func getFollowers(username: String, page: Int) {
        // https://useyourloaf.com/blog/swift-if-case-let/
        showLoadingView()
        isLoadingMoreFollowers = true
        
        Task {
            do {
                let followers = try await networkManager.getFollowers(for: username, page: page)
                updateUI(with: followers)
            } catch {
                if let apiError = error as? ApiError {
                    presentGFAlertOnMainThread(title: "Error", message: apiError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
            }
            dismissLoadingView()
            isLoadingMoreFollowers = false
        }
    }
    
    private func updateUI(with followers: [Follower]) {
        if followers.count < 100 {
            self.hasMoreFollowers = false
        }
        
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them 🥹."
            DispatchQueue.main.async {
                self.showEmptyStateView(with: message, in: self.view)
            }
            return
        }
        self.updateData(on: self.followers)
    }

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot)
        }
    }
    
    @objc func addButtonTapped() {
        viewModel.addAsFollower(userName: self.username)
            .do(onError: { error in
                self.dismissLoadingView()
                if let error = error as? ApiError {
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                } else {
                    self.presentDefaultError()
                }
            }, onCompleted: { // ?? where is doOnFinally?
                self.dismissLoadingView()
                self.presentGFAlertOnMainThread(title: "Success", message: "You have successfully favourited this user", buttonTitle: "Hooray")
            }, onSubscribe: {
                self.showLoadingView()
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
            print("getFollowers")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

extension FollowerListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { 
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

extension FollowerListVC: UserInfoVCDelegate {

    // Reinits all fields and call getFollower API again
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
