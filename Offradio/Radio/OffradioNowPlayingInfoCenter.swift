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
import Kingfisher

class OffradioNowPlayingInfoCenter {
    fileprivate final let disposeBag = DisposeBag()
    
    fileprivate var offradio: Offradio!
    
    init(with radio: Offradio) {
        self.offradio = radio
        
        self.offradio.metadata.nowPlaying.asObservable()
            .skipWhile({ $0.isEmpty() })
            .subscribe(onNext: { [weak self] nowPlaying in
                self?.updateInfo(with: nowPlaying)
            }).disposed(by: disposeBag)
        
        self.offradio.metadata.nowPlaying.asObservable()
            .skipWhile({ $0.isEmpty() })
            .flatMapLatest { nowPlaying -> Observable<UIImage> in
                if let url = URL(string: nowPlaying.current.image) {
                    return KingfisherManager.shared.rx.loadImage(with: url, options: [.forceRefresh])
                        .asObservable()
                }
                return Observable.empty()
            }
            .catchErrorJustReturn(UIImage(named: "artwork-image-placeholder")!)
            .subscribe(onNext: { [weak self] image in
                self?.updateInfo(with: image)
            }).disposed(by: disposeBag)
        
    }
    
    fileprivate func updateInfo(with nowPlaying: NowPlaying) {
        var info: [String: Any] = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
        info[MPMediaItemPropertyTitle]      = nowPlaying.current.track
        info[MPMediaItemPropertyArtist]     = nowPlaying.current.artist
        info[MPMediaItemPropertyAlbumTitle] = "Offradio - \(nowPlaying.show.name)"
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
    
    fileprivate func updateInfo(with image: UIImage) {
        var info: [String: Any] = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
        
        info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size -> UIImage in
            return image
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
    
}
