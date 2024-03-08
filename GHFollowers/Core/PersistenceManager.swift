//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by flamyoad on 27/02/2024.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults: UserDefaults = .standard
    
    enum Keys {
        static let favourites = "favourites"
    }
    
    static func updateWith(favourite: Follower, actionType: PersistenceActionType, completionHandler: @escaping (ApiError?) -> Void) {
        retrieveFavourites { result in
            switch result {
            case .success(let favourites):
                var retrievedFavourites = favourites
                switch actionType {
                case .add:
                    guard !retrievedFavourites.contains(favourite) else {
                        completionHandler(.alreadyInFavourite)
                        return
                    }
                    retrievedFavourites.append(favourite)
                case .remove:
                    retrievedFavourites.removeAll { $0.login == favourite.login }
                }
                completionHandler(save(favourites: retrievedFavourites))
                
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    // Consider to use defaultValue when nil,
    // example value ?? defaultValue
    static func retrieveFavourites(completionHandler: @escaping (Result<[Follower], ApiError>) -> Void) {
        guard let favouritesData = defaults.object(forKey: Keys.favourites) as? Data else {
            completionHandler(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favourites = try decoder.decode([Follower].self, from: favouritesData)
            completionHandler(.success(favourites))
        } catch {
            completionHandler(.failure(.unableToFavourite))
        }
    }
    
    static func save(favourites: [Follower]) -> ApiError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavourites = try encoder.encode(favourites)
            defaults.set(encodedFavourites, forKey: Keys.favourites)
            return nil
        } catch {
            return .unableToFavourite
        }
    }
}
