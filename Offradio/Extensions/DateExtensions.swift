//
//  DateExtensions.swift
//  Carlito
//
//  Created by Dimitris C. on 18/11/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import Foundation

extension Date {
    /// The hour from the specific date or 0 if fails
    var hour: Int {
        return Calendar.autoupdatingCurrent.component(.hour, from: self)
    }

    /// The minute from the specific date or 0 if fails
    var minute: Int {
        return Calendar.autoupdatingCurrent.component(.minute, from: self)
    }

    func nowWithAdjustedHour() -> Date? {
        return Calendar.autoupdatingCurrent.date(bySettingHour: self.hour, minute: self.minute, second: 0, of: Date())
    }

    func adjustTime(bySettingHour hour: Int, minute min: Int = 0, second sec: Int = 0) -> Date? {
        return Calendar.autoupdatingCurrent.date(bySettingHour: hour, minute: min, second: sec, of: self)
    }

    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }

    var unixTimestamp: Double {
        return Double(self.timeIntervalSince1970 * 1000)
    }
}

extension Calendar {
    static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()

    func startOfMonth(for date: Date) -> Date? {
        guard let comp = dateFormatterComponents(from: date) else { return nil }
        return Calendar.formatter.date(from: "\(comp.year) \(comp.month) 01")
    }

    func endOfMonth(for date: Date) -> Date? {
        guard
            let comp = dateFormatterComponents(from: date),
            let day = self.range(of: .day, in: .month, for: date)?.count else {
                return nil
        }

        return Calendar.formatter.date(from: "\(comp.year) \(comp.month) \(day)")
    }

    private func dateFormatterComponents(from date: Date) -> (month: Int, year: Int)? {

        let comp = self.dateComponents([.year, .month], from: date)

        guard
            let month = comp.month,
            let year = comp.year else {
                return nil
        }
        return (month, year)
    }
}
