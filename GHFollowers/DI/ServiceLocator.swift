//
//  ServiceLocator.swift
//  GHFollowers
//
//  Created by flamyoad on 11/03/2024.
//

import Foundation

protocol HasNetworkManager {
    func getNetworkManager() -> NetworkManager
}

protocol HasImageCache {
    func getImageManager() -> ImageManager
}

protocol HasPersistenceManager {
    func getPersistenceManager() -> PersistenceManager
}

// Naive implementation of service locator. needs to be improved
class ServiceLocator: HasNetworkManager, HasImageCache, HasPersistenceManager {
    
    static let shared = ServiceLocator()
    
    private init() {}
    
    func getNetworkManager() -> NetworkManager {
        return NetworkManagerImpl.shared
    }
    
    func getImageManager() -> ImageManager {
        return ImageManagerImpl()
    }
    
    func getPersistenceManager() -> PersistenceManager {
        return PersistenceManagerImpl()
    }
    
}
