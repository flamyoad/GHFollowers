//
//  String+Ext.swift
//  GHFollowers
//
//  Created by flamyoad on 24/02/2024.
//

import Foundation

extension String {
    
    // https://nsdateformatter.com/
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        
        return dateFormatter.date(from: self)
    }
    
    func toReadableDateString() -> String {
        guard let date = self.toDate() else { return "N/A" }
        return date.toMonthYearFormat()
    }
}
