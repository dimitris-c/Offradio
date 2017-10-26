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

struct OffradioStream {
    let url: String = "http://www.offradio.gr/"
    let path: String = "offradio.acc.m3u"
}

final class Offradio: RadioProtocol {

    private var disposeBag = DisposeBag()
    var kit: STKAudioPlayer = STKAudioPlayer()

    var status: RadioState = .stopped
    var isInForeground: Bool = true
    var metadata: RadioMetadata = OffradioMetadata()

    private let m3uService: RxMoyaProvider<M3UService> = RxMoyaProvider<M3UService>()
    private var streamUrl: String = ""

    init() {

        self.configureAudioSession()

        self.setupRadio()

        self.metadata = OffradioMetadata()

        addNotifications()
    }

    final func setupRadio() {
        var options = STKAudioPlayerOptions()
        options.flushQueueOnSeek = true
        options.enableVolumeMixer = true
        self.kit = STKAudioPlayer(options: options)
        self.kit.volume = 1
    }

    final func start() {
        guard self.status != .playing else { return }

        if streamUrl.isEmpty {
            getStreamUrl(shouldStartRadio: true)
        } else {
            self.startRadio()
        }
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
        self.activateAudioSession()
        self.kit.play(self.streamUrl)
        self.metadata.startTimer()
        self.status = .playing
    }

    /// get the stream url from the acc.m3u url
    final fileprivate func getStreamUrl(shouldStartRadio: Bool = false) {
        m3uService.request(.streamUrl).mapString().subscribe(onSuccess: { [weak self] url in
            guard let sSelf = self else { return }
            sSelf.streamUrl = url.replacingOccurrences(of: "\\n*", with: "", options: .regularExpression)
            if shouldStartRadio {
                sSelf.start()
            }
        }, onError: { error in
            Log.error("couldn't load stream url \(error)")
        }).addDisposableTo(disposeBag)
    }

    final fileprivate func configureAudioSession() {
        do {
            Log.debug("AudioSession category is AVAudioSessionCategoryPlayback")
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
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
        if interruptionState.uintValue == AVAudioSessionInterruptionType.began.rawValue {
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
        } else if interruptionState.uintValue == AVAudioSessionInterruptionType.ended.rawValue {
            if let info = info, let reasonInt = info[AVAudioSessionInterruptionOptionKey] as? UInt {
                let interruptionOption = AVAudioSessionInterruptionOptions(rawValue: reasonInt)
                if interruptionOption == AVAudioSessionInterruptionOptions.shouldResume {
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
            if reason.uintValue == AVAudioSessionRouteChangeReason.categoryChange.rawValue {
                if kit.state != STKAudioPlayerState.stopped && self.status == .playing {
                    self.start()
                }
            }
        }
    }

}
