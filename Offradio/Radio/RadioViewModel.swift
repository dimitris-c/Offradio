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

final class RadioViewModel: StormysRadioKitDelegate {

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

    // RadioKit Delegate
    public func srkConnecting() {
        Log.debug("connecting")
        isBuffering.value = true
        isPlaying.value = false
    }

    public func srkisBuffering() {
        Log.debug("buffering")
        isBuffering.value = true
        isPlaying.value = false
    }

    func srkPlayStarted() {
        Log.debug("started")
        isBuffering.value = false
        isPlaying.value = true
        watchCommunication.sendTurnRadioOn()
    }

    func srkPlayStopped() {
        Log.debug("stopped")
        isBuffering.value = false
        isPlaying.value = false
        watchCommunication.sendTurnRadioOff()
    }

    func srkMetaChanged() {
        Log.debug("metadata changed")
        self.radio.metadata.forceRefresh()
    }

    func srkNoNetworkFound() {
        Log.debug("SRK: NoNetworkFound")
    }

    func srkBadContent() {
        Log.debug("SRK: bad content")
    }

    func srkAudioSuspended() {
        Log.debug("SRK: audio suspended")
    }

    func srkQueueExhausted() {
        Log.debug("SRK: queue exhausted")
    }

    func srkAudioWillBeSuspended() {
        Log.debug("SRK: audio will be suspended")
    }

}
