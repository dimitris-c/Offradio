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
import Crashlytics
import StreamingKit

final class RadioViewModel {

    let disposeBag: DisposeBag = DisposeBag()

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

        nowPlaying = radio.metadata.nowPlaying.asDriver()
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
        
//        self.radio.stateChanged
//            .subscribe(onNext: { [weak self, watchCommunication] state in
//                guard let self = self else { return }
//                if state == STKAudioPlayerState.buffering {
//                    self.isBuffering.value = true
//                    self.isPlaying.value = false
//                } else if state == STKAudioPlayerState.playing {
//                    self.isBuffering.value = false
//                    self.isPlaying.value = true
//                    watchCommunication.sendTurnRadioOn()
//                } else if state == STKAudioPlayerState.stopped {
//                    self.isBuffering.value = false
//                    self.isPlaying.value = false
//                    watchCommunication.sendTurnRadioOff()
//                }
//        }).disposed(by: disposeBag)
        
    }

}
