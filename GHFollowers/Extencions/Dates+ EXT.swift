//
//  Dates+ EXT.swift
//  GHFollowers
//
//  Created by Мария  on 30.12.22.
//

import Foundation
extension Date {
    func convertToMonthYearFormat()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
