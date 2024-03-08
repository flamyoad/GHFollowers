//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by flamyoad on 24/02/2024.
//

import Foundation

extension Date {
    
    func toMonthYearFormat() -> String {
        return formatted(.dateTime.month().year())
    }
}
