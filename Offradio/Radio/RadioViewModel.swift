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

    final private(set) var radio: Offradio

    let toggleRadioTriggered: PublishSubject<Bool> = PublishSubject<Bool>()

    let radioState: Signal<RadioState>
    let isBuffering: Signal<Bool>
    let isPlaying: Signal<Bool>

    let nowPlaying: Driver<NowPlaying>

    let watchCommunication: OffradioWatchCommunication

    init(with radio: Offradio, and watchCommunication: OffradioWatchCommunication) {
        self.radio = radio
        self.watchCommunication = watchCommunication

        nowPlaying = radio.metadata.nowPlaying.asDriver(onErrorJustReturn: .empty)
            .do(onNext: { [watchCommunication] track in
                watchCommunication.sendCurrentTrack(with: track.current)
            })
        
        self.radioState = toggleRadioTriggered
            .asObservable()
            .do(onNext: { [radio] shouldTurnRadioOn in
                if shouldTurnRadioOn {
                    radio.start()
                } else {
                    radio.stop()
                }
            })
            .flatMap({ _ -> Observable<RadioState> in
                return radio.stateChanged.map({ state -> RadioState in
                    switch state {
                    case STKAudioPlayerState.buffering:
                        return .buffering
                    case STKAudioPlayerState.playing:
                        return .playing
                    case STKAudioPlayerState.buffering:
                        return .buffering
                    case STKAudioPlayerState.stopped:
                        return .stopped
                    default: return .stopped
                    }
                })
            })
            .asSignal(onErrorSignalWith: .empty())
        
        self.isPlaying = self.radioState.map { $0 == .playing }
            .do(onNext: { _ in
                watchCommunication.sendTurnRadioOn()
            })
            .startWith(false)
        self.isBuffering = self.radioState.map { $0 == .buffering }
            .do(onNext: { _ in
                watchCommunication.sendTurnRadioOff()
            })
            .startWith(false)
        
    }

}
