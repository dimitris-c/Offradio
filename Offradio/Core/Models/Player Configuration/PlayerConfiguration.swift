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
        streams: PlayerStreams(lowBitrateAac: .acc(type: .sd(url: "https://s9.yesstreaming.net:17008/stream")),
                               highBitrateAac: .acc(type: .hd(url: "https://s9.yesstreaming.net:17008/stream")),
                               highBitrateMp3: .mp3(type: .hd(url: "https://s3.yesstreaming.net:17062/stream")),
                               proxyStream: .proxy(url: "https://s5.yesstreaming.net/proxy/offradio2?mp=/live"))
    )
}
