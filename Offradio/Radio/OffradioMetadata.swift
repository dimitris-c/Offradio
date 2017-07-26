//
//  OffradioMetadata.swift
//  Offradio
//
//  Created by Dimitris C. on 27/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa
import RxAlamofire
import Omicron

final class OffradioMetadata {
    fileprivate let disposeBag = DisposeBag()
    
    let nowPlaying: Variable<NowPlaying> = Variable<NowPlaying>(.empty)
    
    fileprivate let crc: Variable<String> = Variable<String>("")
    fileprivate let crcService = RxAPIService<CRCService>()
    fileprivate let lastFMApiService = RxAPIService<LastFMAPIService>()
    fileprivate let nowPlayingService = RxAPIService<NowPlayingService>()
    fileprivate let nowPlayingParser = NowPlayingParse()
    
    fileprivate var timerDisposeBag: DisposeBag?
    
    func startTimer() {
        timerDisposeBag = DisposeBag()
        
        let crcTimer = Observable<Int>.timer(0, period: 14, scheduler: MainScheduler.instance)
        let crcTimerDisposable = crcTimer.asObservable()
            .flatMapLatest({ [weak self] _ -> Observable<String> in
                guard let strongSelf = self else { return Observable.empty() }
                return strongSelf.fetchCRC()
            })
            .bind(to: crc)
        
        let crcDisposable = crc.asObservable()
            .skipWhile { $0.isEmpty }
            .distinctUntilChanged()
            .flatMapLatest { _ -> Observable<NowPlaying> in
                return self.fetchNowPlaying()
            }
            .bind(to: nowPlaying)
        
        timerDisposeBag?.insert(crcDisposable)
        timerDisposeBag?.insert(crcTimerDisposable)
    }
    
    func stopTimer() {
        timerDisposeBag = nil
    }
    
    func forceRefresh() {
        self.fetchNowPlaying()
            .bind(to: nowPlaying)
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func fetchCRC() -> Observable<String> {
        return self.crcService.callString(with: .crc)
    }
    
    func fetchNowPlaying() -> Observable<NowPlaying> {
        return self.nowPlayingService.call(with: .nowPlaying, parse: nowPlayingParser).catchErrorJustReturn(NowPlaying.default)
    }

    // Currently Not Used
    fileprivate func fetchLastFMInfo(with nowPlaying: NowPlaying) -> Observable<NowPlaying> {
        let path: LastFMAPIService = .artistInfo(artist: nowPlaying.current.artist)
        return self.lastFMApiService.call(with: path, parse: LastFMAPIResponseParse()).map({ (artist) -> NowPlaying in
            let filtered = artist.images.filter { $0.size == "mega" || $0.size == "large" }
            if let image = filtered.first {
                return nowPlaying.update(with: image.url)
            }
            return nowPlaying
        })
    }
    
}
