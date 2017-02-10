//
//  Schedule.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

struct ScheduleItem {
    
    let endTime: String
    let startTime: String
    let title: String
    let hasBio: Bool
    
    var isOnAir: Bool = false
    
    var timeTitle: String {
        return "\(startTime) - \(endTime)"
    }
    
    init(with json: JSON) {
        self.startTime  = json["startTime"].stringValue
        self.endTime    = json["endTime"].stringValue
        self.title      = json["title"].stringValue
        self.hasBio     = json["bio"].boolValue
    }
    
    init(withStartTime startTime: String, endTime: String, title: String, hasBio: Bool) {
        self.startTime = startTime
        self.endTime = endTime
        self.title = title
        self.hasBio = hasBio
    }
}

struct Schedule {
    let day: String
    var items: [ScheduleItem] = []
    
    init(with json: JSON) {
        self.day = json["day"].stringValue
        self.items = []
    }
}
