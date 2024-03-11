//
//  FavouriteListViewModel.swift
//  GHFollowers
//
//  Created by flamyoad on 09/03/2024.
//

import Foundation
import RxSwift

class FavouriteListViewModel {
    
    private let persistenceManager: PersistenceManager
    
    init(dependencies: FavouriteListDependencies) {
        self.persistenceManager = dependencies.getPersistenceManager()
    }
    
    func retrieveFavourites() -> Single<[Follower]> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            persistenceManager.retrieveFavourites { result in
                switch result {
                case .success(let followers):
                    single(.success(followers))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
