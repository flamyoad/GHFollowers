//
//  GFSecondaryTitleLabel.swift
//  GHFollowers
//
//  Created by flamyoad on 24/02/2024.
//

import UIKit

class GFSecondaryTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(size: CGFloat) {
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    private func setup() {
        textColor = .secondaryLabel
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
