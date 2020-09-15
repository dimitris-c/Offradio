//
//  Producer.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

struct Producer: Decodable {
    let name: String
    let bio: String
    let image: URL?
    let producerId: Int
}

struct Producer_v2: Decodable, Equatable {
    let day: String
    let timeNow: String
    let producerId: String?
    let producerName: String
    let producerImage: String
    let producerUrl: URL?
    let showTitle: String
    let timeStart: String
    let timeEnd: String
//    let startAt: Date?
//    let endsAt: Date?
    
    static let empty = Producer_v2(day: "", timeNow: "", producerId: "", producerName: "", producerImage: "", producerUrl: nil, showTitle: "", timeStart: "", timeEnd: "")//, startAt: nil, endsAt: nil)

    static let `default` = Producer_v2(day: "", timeNow: "", producerId: "", producerName: "", producerImage: "", producerUrl: nil, showTitle: "Offradio", timeStart: "", timeEnd: "")//, startAt: nil, endsAt: nil)
    
    func isEmpty() -> Bool {
        producerName.isEmpty && showTitle.isEmpty
    }
    
    
    func toDictionary() -> [String: Any] {
        return ["name": producerName,
                "photo": producerImage,
                "largephoto": producerImage,
                "body": showTitle]
    }
}
