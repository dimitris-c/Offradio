//
//  Offradio.swift
//  Offradio
//
//  Created by Dimitris C. on 27/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import MediaPlayer

struct OffradioStream {
    let url: String = "http://www.offradio.gr/offradio.acc.m3u"
    static let radio: Offradio = Offradio()
}

final class Offradio: RadioProtocol {
    let kit: RadioKit = RadioKit()
    private var status = RadioStatus()
    
    var offradioMetadata: OffradioMetadata!
    
    init() {
        let keys = RadioKitAuthenticationKeys()
        
        self.kit.authenticateLibrary(withKey1: keys.key1, andKey2: keys.key2)
        self.setupRadio()
        
        self.offradioMetadata = OffradioMetadata()
        
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
        self.offradioMetadata.startTimer()
        
        status.isPlaying = true
    }
    
    final func stop() {
        guard status.isPlaying && kit.isAudioPlaying() else { return }
        
        self.kit.stopStream()
        self.offradioMetadata.stopTimer()
        
        status.isPlaying = false
    }
    
    final func toggleRadio() {
        if status.isPlaying {
            self.stop()
        } else {
            self.start()
        }
    }
    
}
