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

struct RadioAuthenticationKeys {
    let key1: UInt32 = 0x943e3935
    let key2: UInt32 = 0xe19b0728
}

struct OffradioStream {
    let url: String = "http://www.offradio.gr/offradio.acc.m3u"
    static let radio: Offradio = Offradio()
    
}

struct RadioStatus {
    var isPlaying: Bool = false
    var playbackWasInterrupted: Bool = false
}

final class Offradio: RadioProtocol {
    let kit: RadioKit = RadioKit()
    private var status = RadioStatus()
    
    init() {
        let keys = RadioAuthenticationKeys()
        
        self.kit.authenticateLibrary(withKey1: keys.key1, andKey2: keys.key2)
        self.setupRadio()
        
        if let version = self.kit.version() {
            Log.debug("RadioKit version: \(version)")
        }
    }
    
    final func setupRadio() {
        let offradioStream = OffradioStream()
        self.kit.setStreamUrl(offradioStream.url, isFile: false)
        self.kit.setPauseTimeout(250)
        self.kit.setBufferWaitTime(2)
        self.kit.stopStream()
    }
    
    final func start() {
        guard !status.isPlaying else { return }
        
        self.kit.startStream()
        
        status.isPlaying = true
    }
    
    final func stop() {
        guard status.isPlaying && kit.isAudioPlaying() else { return }
        
        self.kit.stopStream()
        
        status.isPlaying = false
    }
    
}
