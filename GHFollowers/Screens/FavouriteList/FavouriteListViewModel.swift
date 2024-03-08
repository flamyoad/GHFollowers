//
//  FavouriteListViewModel.swift
//  GHFollowers
//
//  Created by flamyoad on 09/03/2024.
//

import Foundation
import RxSwift

class FavouriteListViewModel {
    
    func retrieveFavourites() -> Single<[Follower]> {
        return Single.create { single in
            PersistenceManager.retrieveFavourites { result in
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
