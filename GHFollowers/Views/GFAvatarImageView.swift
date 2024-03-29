//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by flamyoad on 20/02/2024.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let cache: NSCache<NSString, UIImage> = ServiceLocator.shared.getImageManager().getCache()
    
    let placeholderImage = Images.placeholder

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, sl: ServiceLocator) {
        self.init(frame: frame)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
}
