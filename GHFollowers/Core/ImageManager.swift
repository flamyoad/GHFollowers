//
//  ImageCache.swift
//  GHFollowers
//
//  Created by flamyoad on 11/03/2024.
//

import UIKit

protocol ImageManager {
    func getCache() -> NSCache<NSString, UIImage>
    func downloadImage(from urlString: String) async -> UIImage?
}

class ImageManagerImpl: ImageManager {
    
    let cache = NSCache<NSString, UIImage>()
    
    func getCache() -> NSCache<NSString, UIImage> {
        return cache
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) { return image }
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            self.cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
        
    }
}
