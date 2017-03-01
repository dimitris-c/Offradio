//
//  Radio.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import MediaPlayer

protocol RadioProtocol {
    func start()
    func stop()
}

struct RadioKitAuthenticationKeys {
    let key1: UInt32 = 0x943e3935
    let key2: UInt32 = 0xe19b0728
}

struct RadioStatus {
    var isPlaying: Bool = false
    var playbackWasInterrupted: Bool = false
}
