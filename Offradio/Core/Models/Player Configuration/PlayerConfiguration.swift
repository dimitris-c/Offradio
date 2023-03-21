//
//  PlayerConfiguration.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 24/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Foundation

struct PlayerConfiguration: Decodable {
    let streams: PlayerStreams
    
    static let `default` = PlayerConfiguration(
        streams: PlayerStreams(
            lowBitrate: .acc(type: .sd(url: "https://sdstream.offradio.gr")),
            highBitrate: .acc(type: .hd(url: "https://hdstream.offradio.gr"))
        )
    )
}
