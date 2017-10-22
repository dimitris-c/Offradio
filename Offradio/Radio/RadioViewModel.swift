//
//  RadioViewModel.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation
import RxSwift
import Crashlytics
import StreamingKit

final class RadioViewModel: NSObject, StormysRadioKitDelegate, STKAudioPlayerDelegate {

    let disposeBag: DisposeBag = DisposeBag()

    final private(set) var radio: Offradio!

    let toggleRadio: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)

    let isBuffering: Variable<Bool> = Variable<Bool>(false)
    let isPlaying: Variable<Bool> = Variable<Bool>(false)

    let nowPlaying: Variable<NowPlaying> = Variable<NowPlaying>(NowPlaying.empty)

    let watchCommunication: OffradioWatchCommunication!

    init(with radio: Offradio, and watchCommunication: OffradioWatchCommunication) {
        self.radio = radio
        self.watchCommunication = watchCommunication
        super.init()

//        self.radio.kit.delegate = self

        self.radio.kit2.delegate = self

        toggleRadio.asObservable()
            .subscribe(onNext: { [weak self] shouldTurnRadioOn in
                if shouldTurnRadioOn {
                    self?.radio.start()
                } else {
                    self?.radio.stop()
                }
            })
            .addDisposableTo(disposeBag)

        radio.metadata.nowPlaying.asObservable()
            .do(onNext: { [weak self] track in
                self?.watchCommunication.sendCurrentTrack(with: track.current)
            })
            .bind(to: nowPlaying)
            .addDisposableTo(disposeBag)

    }

    // RadioKit Delegate
//    public func srkConnecting() {
//        Log.debug("SRK: radio connecting")
//        isBuffering.value = true
//        isPlaying.value = false
//    }
//
//    public func srkisBuffering() {
//        Log.debug("SRK: radio buffering")
//        isBuffering.value = true
//        isPlaying.value = false
//    }
//
//    func srkPlayStarted() {
//        Log.debug("SRK: radio started")
//        isBuffering.value = false
//        isPlaying.value = true
//        watchCommunication.sendTurnRadioOn()
//    }
//
//    func srkPlayStopped() {
//        Log.debug("SRK: radio stopped")
//        isBuffering.value = false
//        isPlaying.value = false
//        watchCommunication.sendTurnRadioOff()
//    }
//
//    func srkMetaChanged() {
//        Log.debug("SRK: metadata changed")
//        self.radio.metadata.forceRefresh()
//    }
//
//    func srkNoNetworkFound() {
//        Log.debug("SRK: NoNetworkFound")
//    }
//
//    func srkBadContent() {
//        Log.debug("SRK: bad content")
//    }
//
//    func srkAudioSuspended() {
//        Log.debug("SRK: audio suspended")
//    }
//
//    func srkAudioResumed() {
//        Log.debug("SRK: audio resumed")
//    }
//
//    func srkQueueExhausted() {
//        Log.debug("SRK: queue exhausted")
//    }
//
//    func srkAudioWillBeSuspended() {
//        Log.debug("SRK: audio will be suspended")
//    }
//
//    func srkTimeoutExceeded() {
//        Log.debug("SRK: timeout exceeded")
//    }

    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState) {
        if state == STKAudioPlayerState.buffering {
            isBuffering.value = true
            isPlaying.value = false
        } else if state == STKAudioPlayerState.playing {
            isBuffering.value = false
            isPlaying.value = true
        } else if state == STKAudioPlayerState.stopped {
            isBuffering.value = false
            isPlaying.value = false
        }
        Log.debug("audio player state changed: \(state)")
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
