//
//  NowPlayingViewModel.swift
//  Offradio
//
//  Created by Dimitris C. on 01/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa

final class NowPlayingViewModel {
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var radioMetadata: OffradioMetadata!
    
    let currentTrack: Variable<CurrentTrack> = Variable<CurrentTrack>(.empty)
    let show: Variable<Show>                 = Variable<Show>(.default)
    
    init(with radioMetadata: OffradioMetadata) {
        self.radioMetadata = radioMetadata
        
        self.radioMetadata.nowPlaying.asObservable()
            .map { $0.show }
            .startWith(Show.default)
            .bindTo(show)
            .addDisposableTo(disposeBag)
        
        self.radioMetadata.nowPlaying.asObservable()
            .map { $0.current }
            .startWith(CurrentTrack.default)
            .bindTo(currentTrack)
            .addDisposableTo(disposeBag)

    }
    
}
