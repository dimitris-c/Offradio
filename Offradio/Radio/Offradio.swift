//
//  Offradio.swift
//  Offradio
//
//  Created by Dimitris C. on 27/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import MediaPlayer
import RxSwift
import Moya
import StreamingKit
import AVFoundation

final class Offradio: NSObject, RadioProtocol {

    private var disposeBag = DisposeBag()
    var kit: STKAudioPlayer = STKAudioPlayer()

    var status: RadioState = .stopped
    var isInForeground: Bool = true
    var metadata: RadioMetadata = OffradioMetadata()
    
    private var stateChangedSubject = PublishSubject<STKAudioPlayerState>()
    var stateChanged: Observable<STKAudioPlayerState> {
        return self.stateChangedSubject.asObservable()
    }

    override init() {
        super.init()
        self.setupRadio()

        self.metadata = OffradioMetadata()

        addNotifications()
    }

    final func setupRadio() {
        var options = STKAudioPlayerOptions()
        options.bufferSizeInSeconds = 0
        options.readBufferSize = 0
        options.secondsRequiredToStartPlaying = 1
        options.secondsRequiredToStartPlayingAfterBufferUnderun = 1
        options.gracePeriodAfterSeekInSeconds = 0
        options.enableVolumeMixer = true
        self.kit = STKAudioPlayer(options: options)
        self.kit.volume = 1
        self.kit.delegate = self
    }

    final func start() {
        guard self.status != .playing else { return }

        self.startRadio()
    }

    final func stop() {

        self.kit.stop()
        self.metadata.stopTimer()

        self.status = .stopped

    }

    final func toggleRadio() {
        if self.status == .playing {
            self.stop()
        } else {
            self.start()
        }
    }

    final fileprivate func startRadio() {
        self.configureAudioSession()
        self.activateAudioSession()
        // http://46.28.53.118:7033/stream
        // http://s3.yesstreaming.net:7033/stream
        // http://94.23.214.108/proxy/offradio2?mp=/stream
//        self.kit.play("http://s3.yesstreaming.net:7033/stream")
        self.kit.play("http://94.23.214.108/proxy/offradio2?mp=/stream")
        self.metadata.startTimer()
        self.status = .playing
    }

    final fileprivate func configureAudioSession() {
        do {
            Log.debug("AudioSession category is AVAudioSessionCategoryPlayback")
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        } catch let error as NSError {
            Log.debug("Couldn't setup audio session category to Playback \(error.localizedDescription)")
        }
    }

    final fileprivate func activateAudioSession() {
        do {
            Log.debug("AudioSession is active")
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            Log.debug("Couldn't set audio session to active: \(error.localizedDescription)")
        }
    }

    final fileprivate func deactivateAudioSession() {
        do {
            Log.debug("AudioSession is deactivated")
            try AVAudioSession.sharedInstance().setActive(false)
        } catch let error as NSError {
            Log.debug("Couldn't deactivate audio session: \(error.localizedDescription)")
        }
    }
}

extension Offradio: STKAudioPlayerDelegate {
    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState) {
        stateChangedSubject.onNext(state)
        Log.debug("audio player state changed: \(state)")
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didReadStreamMetadata dictionary: [AnyHashable: Any]) {
        Log.debug("audio player received metadata: \(dictionary)")
        self.metadata.forceRefresh()
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject) {
        Log.debug("audio player did start playing")
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
        Log.debug("audio player did finish buffering")
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double) {
        Log.debug("audio player did finish playing reason: \(stopReason)")
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode) {
        Log.debug("audio player error: \(errorCode)")
    }
}

extension Offradio {

    final fileprivate func addNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleInterruption),
                                               name: AVAudioSession.interruptionNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRouteChange),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleMediaReset),
                                               name: AVAudioSession.mediaServicesWereResetNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(movedToBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(movedToForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    @objc final fileprivate func handleMediaReset() {
        Log.debug("handle system media reset")
        self.status = .stopped
        self.metadata.stopTimer()
        self.setupRadio()
        self.deactivateAudioSession()
        self.configureAudioSession()
    }

    @objc final fileprivate func movedToBackground() {
        Log.debug("app moved to background")
        isInForeground = false
        self.metadata.stopTimer()
        if self.status != .playing {
            self.deactivateAudioSession()
        }
    }

    @objc final fileprivate func movedToForeground() {
        if status == .playing && !isInForeground {
            self.metadata.startTimer()
        }
        Log.debug("app moved to foreground")
        isInForeground = true
    }

    @objc final fileprivate func handleInterruption(_ notification: Notification) {
        let info = notification.userInfo
        Log.debug("audio interruption\n\(String(describing: info))")
        print("\(String(describing: info))")

        guard let interruptionState = info?[AVAudioSessionInterruptionTypeKey] as? NSNumber else { return }

        let audioPlayerState = kit.state
        if interruptionState.uintValue == AVAudioSession.InterruptionType.began.rawValue {
            var wasSuspended: Bool = false
            if #available(iOS 10.3, *) {
                wasSuspended = info?[AVAudioSessionInterruptionWasSuspendedKey] as? Bool ?? false
            }
            Log.debug("audio interruption began")
            if audioPlayerState != STKAudioPlayerState.stopped && !wasSuspended {
                Log.debug("audio should stop")
                self.stop()
                // set the status to interrupted after stopping the audio
                self.status = .interrupted
            }
        } else if interruptionState.uintValue == AVAudioSession.InterruptionType.ended.rawValue {
            if let info = info, let reasonInt = info[AVAudioSessionInterruptionOptionKey] as? UInt {
                let interruptionOption = AVAudioSession.InterruptionOptions(rawValue: reasonInt)
                if interruptionOption == AVAudioSession.InterruptionOptions.shouldResume {
                    Log.debug("audio shouldResume after interruption")
                    if audioPlayerState == STKAudioPlayerState.stopped && self.status == .interrupted {
                        Log.debug("offradio should resume playback interruption")
                        self.start()
                    }
                }
            }
        }
    }

    @objc final fileprivate func handleRouteChange(_ notification: Notification) {
        Log.debug("audio route change\n\(String(describing: notification.userInfo))")
        if let reason: NSNumber = notification.userInfo?[AVAudioSessionRouteChangeReasonKey] as? NSNumber {
            if reason.uintValue == AVAudioSession.RouteChangeReason.categoryChange.rawValue {
                if kit.state != STKAudioPlayerState.stopped && self.status == .playing {
                    self.start()
                }
            }
        }
    }

}
