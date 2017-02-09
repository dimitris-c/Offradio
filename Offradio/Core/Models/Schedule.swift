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
    
    var timeTitle: String {
        return "\(endTime) - \(startTime)"
    }
    
    init(with json: JSON) {
        self.startTime  = json["startTime"].stringValue
        self.endTime    = json["endTime"].stringValue
        self.title      = json["title"].stringValue
        self.hasBio     = json["bio"].boolValue
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
