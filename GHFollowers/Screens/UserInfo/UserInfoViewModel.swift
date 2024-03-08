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
    
    func getUserInfo(for username: String) -> Single<User> {
        return Single.create { single in
            let task = Task {
                do {
                    let userInfo = try await NetworkManager.shared.getUserInfo(for: username)
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
