//
//  DaterFormat.swift
//  Offradio
//
//  Created by Dimitris C. on 13/09/2016.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

enum DateFormatType {
    case api
    case apiAlternate
    case token
}

final class DateFormat: NSObject {

    static let api:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.0"
        return dateFormatter
    }()
    
    static let token:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return dateFormatter
    }()
    
    static let apiAlternate:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        return dateFormatter
    }()
    
    final var date: Date?
    
    init(with string: String, type: DateFormatType = .api) {
        super.init()
        
        switch type {
        case .api:
            self.date = type(of: self).api.date(from: string)
            break
        case .apiAlternate:
            self.date = type(of: self).apiAlternate.date(from: string)
            break
        case .token:
            self.date = type(of: self).token.date(from: string)
            break
        }
    }
}
