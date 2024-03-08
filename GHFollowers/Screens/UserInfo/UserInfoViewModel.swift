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
    
    // ??? Single please
    func getUserInfo(for username: String) -> Observable<User> {
        return Observable.create { observable in
            let task = Task {
                do {
                    let userInfo = try await NetworkManager.shared.getUserInfo(for: username)
                    observable.onNext(userInfo)
                    observable.onCompleted()
                } catch {
                    observable.onError(error)
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
