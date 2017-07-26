//
//  DateExtensions.swift
//  Carlito
//
//  Created by Dimitris C. on 18/11/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import Foundation

extension Date {

    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }

    var unixTimestamp: Double {
        return Double(self.timeIntervalSince1970 * 1000)
    }
}
