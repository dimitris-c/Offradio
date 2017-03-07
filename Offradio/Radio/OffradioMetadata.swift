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

final class OffradioMetadata {
    
    let nowPlaying: Variable<NowPlaying> = Variable<NowPlaying>(.empty)
    
    fileprivate let crc: Variable<String> = Variable<String>("")
    fileprivate let crcService: CRCService = CRCService()
    fileprivate var lastFMApiService: LastFMApiService!
    fileprivate var nowPlayingService: NowPlayingService!
    
    fileprivate var timerDisposeBag: DisposeBag?
    
    func startTimer() {
        timerDisposeBag = DisposeBag()
        
        let crcTimer = Observable<Int>.timer(0, period: 14, scheduler: MainScheduler.instance)
        let crcTimerDisposable = crcTimer.asObservable()
            .flatMapLatest({ [weak self] _ -> Observable<String> in
                guard let strongSelf = self else { return Observable.empty() }
                return strongSelf.fetchCRC()
            })
            .bindTo(crc)
        
        let crcDisposable = crc.asObservable()
            .distinctUntilChanged()
            .flatMapLatest { _ -> Observable<NowPlaying> in
                return self.fetchNowPlaying()
            }
            .bindTo(nowPlaying)
        
        timerDisposeBag?.insert(crcDisposable)
        timerDisposeBag?.insert(crcTimerDisposable)
    }
    
    func stopTimer() {
        timerDisposeBag = nil
    }
    
    func forceRefresh() {
        stopTimer()
        startTimer()
    }
    
    fileprivate func fetchCRC() -> Observable<String> {
        return self.crcService.request.toAlamofire().rx.string()
    }
    
    fileprivate func fetchNowPlaying() -> Observable<NowPlaying> {
        self.nowPlayingService = NowPlayingService()
        return self.nowPlayingService.rxCall()
    }

    // Currently Not Used
    fileprivate func fetchLastFMInfo(with nowPlaying: NowPlaying) -> Observable<NowPlaying> {
        self.lastFMApiService = LastFMApiService(with: nowPlaying.current.artist)
        return self.lastFMApiService.rxCall().map({ (artist) -> NowPlaying in
            let filtered = artist.images.filter { $0.size == "mega" }
            if let image = filtered.first {
                return nowPlaying.update(with: image.url)
            }
            return nowPlaying
        })
    }
    
}
