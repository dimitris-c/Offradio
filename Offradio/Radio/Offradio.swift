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
import RxCocoa
import Network

enum OffradioStreamQuality {
    case sd
    case hd
    
    var url: String {
        switch self {
            case .hd:
                return "https://s3.yesstreaming.net:17062/stream"
            case .sd:
                return "https://s3.yesstreaming.net:17033/stream"
        }
    }
    
    static func quality(from connectionType: NetConnectionType) -> Self {
        switch connectionType {
            case .cellular: return .sd
            case .wifi: return .hd
            case .undetermined: return .sd
        }
    }
}

final class Offradio: NSObject, RadioProtocol {
    
    private var isInForeground: Bool = true
    private var audioPlayer = STKAudioPlayer()
    
    private let netStatusService: NetStatusService
    
    var status: RadioState = .stopped
    let metadata: RadioMetadata
    
    private var stateChangedSubject = PublishSubject<STKAudioPlayerState>()
    var stateChanged: Observable<STKAudioPlayerState> {
        return self.stateChangedSubject.asObservable()
    }
    
    override init() {
        self.metadata = OffradioMetadata()
        self.netStatusService = NetStatusService(network: NWPathMonitor())
        super.init()
        self.configureAudioSession()
        self.addNotifications()
        self.setupRadio()
        
        self.netStatusService.start { [weak self] connectionType in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.status == .playing || self.status == .buffering {
                    self.adjustAudioStreamQuality(for: connectionType)
                }
            }
        }
    }
    
    final func setupRadio() {
        var options = STKAudioPlayerOptions()
        options.bufferSizeInSeconds = 4
        options.secondsRequiredToStartPlaying = 1
        options.secondsRequiredToStartPlayingAfterBufferUnderun = 1
        options.enableVolumeMixer = true
        options.flushQueueOnSeek = false
        self.audioPlayer = STKAudioPlayer(options: options)
        self.audioPlayer.volume = 1.0
        self.audioPlayer.delegate = self
    }
    
    final func adjustAudioStreamQuality(for connectionType: NetConnectionType) {
        self.startRadio(with: OffradioStreamQuality.quality(from: connectionType))
    }
    
    final func start(with quality: OffradioStreamQuality) {
        guard self.status != .playing else { return }
        
        self.startRadio(with: quality)
        
        self.status = .playing
    }
    
    final func start() {
        guard self.status != .playing else { return }
        
        self.adjustAudioStreamQuality(for: self.netStatusService.connectionType)
        
        self.status = .playing
    }
    
    final func stop() {
        self.audioPlayer.stop()
        self.metadata.closeSocket()
//        self.netStatusService.stop()
        
        self.status = .stopped
    }
    
    final func toggleRadio() {
        if self.status == .playing {
            self.stop()
        } else {
            self.start()
        }
    }
    
    final fileprivate func startRadio(with quality: OffradioStreamQuality) {
        self.activateAudioSession()
        
        print(quality, quality.url)
        
        self.audioPlayer.play(quality.url)
        
        self.metadata.openSocket()
    }
    
    final fileprivate func configureAudioSession() {
        do {
            Log.debug("AudioSession category is AVAudioSessionCategoryPlayback")
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .longFormAudio, options: [])
            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(0.1)
        } catch let error as NSError {
            Log.debug("Couldn't setup audio session category to Playback \(error.localizedDescription)")
        }
    }
    
    final fileprivate func activateAudioSession() {
        do {
            Log.debug("AudioSession is active")
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
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
        switch errorCode {
            case STKAudioPlayerErrorCode.audioSystemError,
                 STKAudioPlayerErrorCode.codecError,
                 STKAudioPlayerErrorCode.dataNotFound:
                self.setupRadio()
                self.start()
            default:
                break
        }
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
        self.metadata.closeSocket()
        
        self.setupRadio()
        self.deactivateAudioSession()
        self.configureAudioSession()
    }
    
    @objc final fileprivate func movedToBackground() {
        Log.debug("app moved to background")
        isInForeground = false
        self.metadata.closeSocket()
        if self.status != .playing {
            self.deactivateAudioSession()
        }
    }
    
    @objc final fileprivate func movedToForeground() {
        if status == .playing && !isInForeground {
            self.metadata.openSocket()
        }
        Log.debug("app moved to foreground")
        isInForeground = true
    }
    
    @objc final fileprivate func handleInterruption(_ notification: Notification) {
        let info = notification.userInfo
        Log.debug("audio interruption\n\(String(describing: info))")
        
        guard let interruptionState = info?[AVAudioSessionInterruptionTypeKey] as? NSNumber else { return }
        
        let audioPlayerState = audioPlayer.state
        if interruptionState.uintValue == AVAudioSession.InterruptionType.began.rawValue {
            let wasSuspended: Bool = info?[AVAudioSessionInterruptionWasSuspendedKey] as? Bool ?? false
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
                    if (audioPlayerState == .stopped || audioPlayerState == .disposed) && self.status == .interrupted {
                        Log.debug("offradio should resume playback interruption")
                        self.start()
                    }
                }
            }
        }
    }
    
    @objc final fileprivate func handleRouteChange(_ notification: Notification) {
        Log.debug("audio route change//\n\(String(describing: notification.userInfo))")
        guard let reasonNumber = notification.userInfo?[AVAudioSessionRouteChangeReasonKey] as? NSNumber,
            let reason = AVAudioSession.RouteChangeReason(rawValue: UInt(reasonNumber.int32Value)) else {
                return
        }
        switch reason {
            case .oldDeviceUnavailable:
                self.stop()
            default:
                break
        }
    }
    
}
