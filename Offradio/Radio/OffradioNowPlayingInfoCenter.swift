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
import StreamingKit

class OffradioNowPlayingInfoCenter {
    fileprivate final let disposeBag = DisposeBag()
    
    fileprivate let offradio: Offradio
    
    init(with radio: Offradio) {
        self.offradio = radio
        
        let nowPlaying = self.offradio.metadata.nowPlaying
            .share(replay: 1, scope: .whileConnected)
        
        nowPlaying
            .skipWhile({ $0.isEmpty() })
            .subscribe(onNext: { [weak self] nowPlaying in
                self?.updateInfo(with: nowPlaying)
            }).disposed(by: disposeBag)
        
        let placeholder = UIImage(named: "artwork-image-placeholder")!
        nowPlaying
            .skipWhile({ $0.isEmpty() })
            .distinctUntilChanged()
            .flatMapLatest { nowPlaying -> Observable<UIImage?> in
                if let url = URL(string: nowPlaying.track.image) {
                    return URLSession.shared.rx.data(request: URLRequest(url: url))
                        .map({ data -> UIImage? in
                            return UIImage(data: data) ?? placeholder
                        })
                }
                return .just(placeholder)
            }
            .catchErrorJustReturn(placeholder)
            .subscribe(onNext: { [weak self] image in
                if let image = image {
                    self?.updateInfo(with: image)                    
                }
            }).disposed(by: disposeBag)
        
        self.offradio.stateChanged
            .withLatestFrom(nowPlaying) { ($0, $1) }
            .map { (state, nowPlaying) -> NowPlaying in
                if state == STKAudioPlayerState.playing || state == STKAudioPlayerState.buffering {
                    return nowPlaying
                } else {
                    return NowPlaying(track: .default, producer: nowPlaying.producer)
                }
            }
            .subscribe { [weak self] nowPlaying in
                self?.updateInfo(with: nowPlaying)
            }
            .disposed(by: disposeBag)

    }
    
    fileprivate func updateInfo(with nowPlaying: NowPlaying) {
        var info: [String: Any] = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
        info[MPMediaItemPropertyTitle]      = nowPlaying.track.name
        info[MPMediaItemPropertyArtist]     = nowPlaying.track.artist
        info[MPMediaItemPropertyAlbumTitle] = "Offradio - \(nowPlaying.producer.producerName)"
        info[MPNowPlayingInfoPropertyIsLiveStream] = true
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
