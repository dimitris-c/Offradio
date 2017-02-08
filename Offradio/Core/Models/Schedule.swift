//
//  Schedule.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

struct ScheduleItem {
    let endTime: String
    let startTime: String
    let title: String
    let bio: Bool
}

struct Schedule {
    let day: String
    let items: [ScheduleItem]
}
