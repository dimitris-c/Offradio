//
//  Schedule.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//
import Foundation

struct ScheduleItem: Decodable {
   
    let producer: String
    let showTitle: String
    let timeStart: String
    let timeEnd: String
    let producerId: String?
    let producerBio: String?
    let image: URL?

    var hasBio: Bool {
        guard let bio = producerBio, !bio.isEmpty else {
            return false
        }
        return true
    }
    
    var title: String {
        if producer.isEmpty {
            return showTitle
        }
        return producer
    }

    var timeTitle: String {
        return "\(timeStart) - \(timeEnd)"
    }

}

struct Schedule: Decodable {
    let day: String
    let shows: [ScheduleItem]

    var dayFormatted: String {
        return "Schedule - \(day)"
    }
}
