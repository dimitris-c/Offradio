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
import Moya
import SwiftyJSON

final class OffradioMetadata: RadioMetadata {
    fileprivate let disposeBag = DisposeBag()

    let forceRefreshObservable = PublishRelay<Void>()
    let nowPlaying: Driver<NowPlaying>

    fileprivate let crc: Driver<String>
    fileprivate let crcService = MoyaProvider<CRCService>()
    fileprivate let lastFMApiService = MoyaProvider<LastFMAPIService>()
    fileprivate let nowPlayingService = MoyaProvider<NowPlayingService>()
    fileprivate let nowPlayingParser = NowPlayingParse()

    fileprivate var timerDisposeBag: DisposeBag?
    
    init() {
        let crcTimer = Observable<Int>.timer(0, period: 14, scheduler: MainScheduler.instance)
        crc = crcTimer.asObservable()
            .flatMapLatest({ [weak self] _ -> Observable<String> in
                guard let strongSelf = self else { return Observable.empty() }
                return strongSelf.crcService.rx.request(.crc).mapString().asObservable()
            })
            .asDriver(onErrorJustReturn: "")
        
        nowPlaying = Observable.merge(crc.asObservable(), forceRefreshObservable.asObservable().map { _ in "" })
            .skipWhile { $0.isEmpty }
            .distinctUntilChanged()
            .flatMapLatest { [weak self] _ -> Observable<NowPlaying> in
                guard let self = self else { return Observable.just(NowPlaying.default) }
                return self.fetchNowPlaying()
            }
            .asDriver(onErrorJustReturn: NowPlaying.default)
    }

    func startTimer() {
//        timerDisposeBag = DisposeBag()

        

//        timerDisposeBag?.insert(crcDisposable)
//        timerDisposeBag?.insert(crcTimerDisposable)
    }

    func stopTimer() {
//        timerDisposeBag = nil
    }

    func forceRefresh() {
        forceRefreshObservable.accept(())
    }

    func fetchNowPlaying() -> Observable<NowPlaying> {
        return self.nowPlayingService.rx.request(.nowPlaying)
            .mapJSON()
            .map { NowPlaying(json: JSON($0)) }
            .asObservable()
            .catchErrorJustReturn(NowPlaying.default)
            .flatMapLatest({ (nowPlaying) -> Observable<NowPlaying> in
                return self.fetchLastFMInfo(with: nowPlaying)
            })
    }

    // Currently Not Used
    fileprivate func fetchLastFMInfo(with nowPlaying: NowPlaying) -> Observable<NowPlaying> {
        let path: LastFMAPIService = .artistInfo(artist: nowPlaying.current.artist)
        return self.lastFMApiService.rx.request(path)
            .mapJSON()
            .map { JSON($0) }
            .map { LastFMArtist(with: $0["artist"]) }
            .map { artist -> NowPlaying in
                let filtered = artist.images.filter { $0.size == "mega" || $0.size == "large" }
                if let image = filtered.first {
                    return nowPlaying.update(with: image.url)
                }
                return nowPlaying
            }
            .asObservable()
            .catchErrorJustReturn(.empty)
    }

}
