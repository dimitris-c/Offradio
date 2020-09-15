//
//  NowPlaying.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

struct NowPlaying_v2: Decodable, Equatable {
    let track: CurrentTrack_v2
    let producer: Producer_v2
    
    static let empty = NowPlaying_v2(track: .empty, producer: .empty)
    
    static let `default` = NowPlaying_v2(track: .default, producer: .default)
    
    func isEmpty() -> Bool {
        self.track.isEmpty() && self.producer.isEmpty()
    }
}
