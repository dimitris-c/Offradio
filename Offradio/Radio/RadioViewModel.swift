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

final class RadioViewModel: NSObject, STKAudioPlayerDelegate {

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

        self.radio.kit.delegate = self

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

    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState) {
        if state == STKAudioPlayerState.buffering {
            isBuffering.value = true
            isPlaying.value = false
        } else if state == STKAudioPlayerState.playing {
            isBuffering.value = false
            isPlaying.value = true
            watchCommunication.sendTurnRadioOn()
        } else if state == STKAudioPlayerState.stopped {
            isBuffering.value = false
            isPlaying.value = false
            watchCommunication.sendTurnRadioOff()
        }
        Log.debug("audio player state changed: \(state)")
    }

    func audioPlayer(_ audioPlayer: STKAudioPlayer, didReadStreamMetadata dictionary: [AnyHashable : Any]) {
        Log.debug("audio player received metadata: \(dictionary)")
        self.radio.metadata.forceRefresh()
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
