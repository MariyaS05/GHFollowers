//
//  String + EXT.swift
//  GHFollowers
//
//  Created by Мария  on 30.12.22.
//

import Foundation
extension String {
    func convertToDate()-> Date? {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .autoupdatingCurrent
        return dateFormatter.date(from: self)
    }
    func convertToDisplayFormat()-> String {
        guard let date  = self.convertToDate() else {return "N/A"}
        return date.convertToMonthYearFormat()
    }
}
