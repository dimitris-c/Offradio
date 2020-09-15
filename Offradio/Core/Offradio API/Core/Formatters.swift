//
//  Formatters.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 14/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Foundation

struct Formatters {
    static var apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static var playlistFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
