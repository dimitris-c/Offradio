//
//  OffradioNowPlayingInfoCenter.swift
//  Offradio
//
//  Created by Dimitris C. on 28/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import MediaPlayer
import RxSwift
import RxCocoa

class OffradioNowPlayingInfoCenter {
    fileprivate final let disposeBag = DisposeBag()
    
    fileprivate var offradio: Offradio!
    
    init(with radio: Offradio) {
        self.offradio = radio
        
        
        self.offradio.offradioMetadata.nowPlaying.asObservable().subscribe(onNext: { nowPlaying in
            let info: [String: Any] = [MPMediaItemPropertyTitle: nowPlaying.current.track,
                                       MPMediaItemPropertyArtist: nowPlaying.current.artist]
            MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        }).addDisposableTo(disposeBag)
        
        
    }
    
}
