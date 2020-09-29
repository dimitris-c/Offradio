//
//  RadioViewModel.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAnalytics
import StreamingKit

final class RadioViewModel {

    private let interfaceFeedback: InterfaceFeedbackType
    private let radio: Offradio

    let toggleRadioTriggered: PublishSubject<Bool> = PublishSubject<Bool>()

    let radioState: Signal<RadioState>
    let isBuffering: Signal<Bool>
    let isPlaying: Signal<Bool>

    let nowPlaying: Driver<NowPlaying>

    let watchCommunication: OffradioWatchCommunication

    init(with radio: Offradio, and watchCommunication: OffradioWatchCommunication, interfaceFeedback: InterfaceFeedbackType) {
        self.radio = radio
        self.watchCommunication = watchCommunication
        self.interfaceFeedback = interfaceFeedback

        nowPlaying = radio.metadata.nowPlaying.asDriver(onErrorJustReturn: .empty)
            .do(onNext: { [watchCommunication] nowPlaying in
                watchCommunication.sendCurrentTrack(with: nowPlaying.track)
            })
        
        self.radioState = toggleRadioTriggered
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .do(onNext: { [radio] shouldTurnRadioOn in
                interfaceFeedback.fireFeedback()
                if shouldTurnRadioOn {
                    radio.start()
                } else {
                    radio.stop()
                }
            })
            .flatMap({ _ -> Observable<RadioState> in
                return radio.stateChanged
                    .map({ state -> RadioState in
                    switch state {
                    case STKAudioPlayerState.buffering:
                        return .buffering
                    case STKAudioPlayerState.playing:
                        return .playing
                    case STKAudioPlayerState.stopped:
                        return .stopped
                    default: return .stopped
                    }
                })
            })
            .distinctUntilChanged()
            .do(onNext: { state in
                let isPlaying = state == .playing
                if isPlaying {
                    watchCommunication.sendTurnRadioOn()
                } else if state == .stopped {
                    watchCommunication.sendTurnRadioOff()
                }
            })
            .asSignal(onErrorSignalWith: .empty())
        
        self.isPlaying = self.radioState
            .map { $0 == .playing }
            .startWith(false)
        
        self.isBuffering = self.radioState
            .map { $0 == .buffering }
            .startWith(false)
    }

}
