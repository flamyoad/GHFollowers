//
//  FollowerListViewModel.swift
//  GHFollowers
//
//  Created by flamyoad on 11/03/2024.
//

import Foundation
import RxSwift
import RxRelay

enum FollowerListState {
    case Loading
    case Error
    case Empty
}

class FollowerListViewModel {
    
    private let networkManager: NetworkManager
    private let persistenceManager: PersistenceManager
    
    init(dependencies: FollowerListDependencies) {
        networkManager = dependencies.getNetworkManager()
        persistenceManager = dependencies.getPersistenceManager()
    }
        
    func addAsFollower(userName: String) -> Completable {
        return getUserInfo(for: userName)
            .map { Follower(login: $0.login, avatarUrl: $0.avatarUrl) }
            .flatMapCompletable { self.saveFollowerToDb(follower: $0) }
    }
    
    // ???? stupid
    private func saveFollowerToDb(follower: Follower) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create() }
            self.persistenceManager.updateWith(favourite: follower, actionType: .add) { error in
                if let error = error {
                    completable(.error(error))
                }
                completable(.completed)
            }
            return Disposables.create()
        }
    }

    // should be converted to rx in usecase class instead of vm
    private func getUserInfo(for username: String) -> Single<User> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            let task = Task {
                do {
                    let userInfo = try await self.networkManager.getUserInfo(for: username)
                    single(.success(userInfo))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
