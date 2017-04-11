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
    var status = RadioStatus()
    var isInForeground: Bool = true
    var metadata: OffradioMetadata!
    
    init() {
        let keys = RadioKitAuthenticationKeys()
        
        self.kit.authenticateLibrary(withKey1: keys.key1, andKey2: keys.key2)
        self.setupRadio()
        
        self.metadata = OffradioMetadata()
        
        if let version = self.kit.version() {
            Log.debug("RadioKit version: \(version)")
        }
        
        addNotifications()
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
        self.metadata.startTimer()
        
        status.isPlaying = true
    }
    
    final func stop() {
        guard status.isPlaying && kit.isAudioPlaying() else { return }
        
        self.kit.stopStream()
        self.metadata.stopTimer()
        
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

extension Offradio {
    
    final fileprivate func addNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleInterruption),
                                               name: NSNotification.Name.AVAudioSessionInterruption,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRouteChange),
                                               name: NSNotification.Name.AVAudioSessionRouteChange,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(movedToBackground),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(movedToForeground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
    }
    
    @objc final fileprivate func movedToBackground() {
        isInForeground = false
        self.metadata.stopTimer()
    }
    
    @objc final fileprivate func movedToForeground() {
        if status.isPlaying && !isInForeground {
            self.metadata.startTimer()
        }
        isInForeground = true
    }
    
    @objc final fileprivate func handleInterruption(_ notification: Notification) {
        let info = notification.userInfo
        print("\(String(describing: info))")
        
        guard let interruptionState = info?[AVAudioSessionInterruptionTypeKey] as? NSNumber else { return }
        if interruptionState.uintValue == AVAudioSessionInterruptionType.began.rawValue {
            if kit.getStreamStatus() == SRK_STATUS_PLAYING || kit.getStreamStatus() == SRK_STATUS_PAUSED {
                self.status.playbackWasInterrupted = true
                self.stop()
            }
        }
        else if interruptionState.uintValue == AVAudioSessionInterruptionType.ended.rawValue {
            if let info = info, let reasonInt = info[AVAudioSessionInterruptionOptionKey] as? UInt {
                let interruptionOption = AVAudioSessionInterruptionOptions(rawValue: reasonInt)
                if interruptionOption == AVAudioSessionInterruptionOptions.shouldResume {
                    if self.status.playbackWasInterrupted {
                        self.status.playbackWasInterrupted = false
                        self.start()
                    }
                }
            }
        }
    }
    
    @objc final fileprivate func handleRouteChange(_ notification: Notification) {
        print("\(String(describing: notification.userInfo))")
        if let reason: NSNumber = notification.userInfo?[AVAudioSessionRouteChangeReasonKey] as? NSNumber {
            if (reason.uintValue == AVAudioSessionRouteChangeReason.categoryChange.rawValue) {
                if kit.getStreamStatus() == SRK_STATUS_PAUSED && status.isPlaying {
                    self.start()
                }
            }
        }
    }

}
