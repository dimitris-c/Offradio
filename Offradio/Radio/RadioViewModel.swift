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

    let toggleRadio: PublishSubject<Bool> = PublishSubject<Bool>()

    let isBuffering: Variable<Bool> = Variable<Bool>(false)
    let isPlaying: Variable<Bool> = Variable<Bool>(false)

    let nowPlaying: Driver<NowPlaying>

    let watchCommunication: OffradioWatchCommunication

    init(with radio: Offradio, and watchCommunication: OffradioWatchCommunication) {
        self.radio = radio
        self.watchCommunication = watchCommunication

        nowPlaying = radio.metadata.nowPlaying.asDriver()
            .do(onNext: { [watchCommunication] track in
                watchCommunication.sendCurrentTrack(with: track.current)
            })

        toggleRadio.asObservable()
            .subscribe(onNext: { [weak self] shouldTurnRadioOn in
                if shouldTurnRadioOn {
                    self?.radio.start()
                } else {
                    self?.radio.stop()
                }
            })
            .disposed(by: disposeBag)
        
        self.radio.stateChanged
            .subscribe(onNext: { [weak self, watchCommunication] state in
                guard let self = self else { return }
                if state == STKAudioPlayerState.buffering {
                    self.isBuffering.value = true
                    self.isPlaying.value = false
                } else if state == STKAudioPlayerState.playing {
                    self.isBuffering.value = false
                    self.isPlaying.value = true
                    watchCommunication.sendTurnRadioOn()
                } else if state == STKAudioPlayerState.stopped {
                    self.isBuffering.value = false
                    self.isPlaying.value = false
                    watchCommunication.sendTurnRadioOff()
                }
        }).disposed(by: disposeBag)
        
    }

}
