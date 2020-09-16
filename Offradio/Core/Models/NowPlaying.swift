//
//  NowPlaying.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

struct NowPlaying: Decodable, Equatable {
    let track: CurrentTrack
    let producer: ProducerShow
    
    static let empty = NowPlaying(track: .empty, producer: .empty)
    
    static let `default` = NowPlaying(track: .default, producer: .default)
    
    func isEmpty() -> Bool {
        self.track.isEmpty() && self.producer.isEmpty()
    }
}
