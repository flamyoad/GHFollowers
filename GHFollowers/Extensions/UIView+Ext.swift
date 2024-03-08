//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by flamyoad on 02/03/2024.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
