//
//  UserInfoViewModel.swift
//  GHFollowers
//
//  Created by flamyoad on 09/03/2024.
//

import Foundation
import RxSwift
import RxRelay

class UserInfoViewModel {
    
    private let networkManager: NetworkManager
    
    init(dependencies: UserInfoDependencies) {
        self.networkManager = dependencies.getNetworkManager()
    }
    
    func getUserInfo(for username: String) -> Single<User> {
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
