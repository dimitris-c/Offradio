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
    
    private let queue = ConcurrentDispatchQueueScheduler(qos: .background)
    let nowPlaying: Observable<NowPlaying>
    
    fileprivate let refresh = PublishRelay<Void>()
    fileprivate let crc = PublishRelay<String>()
    fileprivate let crcService = MoyaProvider<CRCService>()
    fileprivate let lastFMApiService = MoyaProvider<LastFMAPIService>()
    fileprivate let nowPlayingService = MoyaProvider<NowPlayingService>()
    
    fileprivate var timerDisposeBag: DisposeBag?
    
    public init() {
        
        let fetchNowPlaying = self.nowPlayingService.rx.request(.nowPlaying)
            .observeOn(queue)
            .mapJSON()
            .map { NowPlaying(json: JSON($0)) }
            .asObservable()
            .catchErrorJustReturn(NowPlaying.default)
        
        nowPlaying = Observable.merge(crc.asObservable(), refresh.map { _ in "" })
            .skipWhile { $0.isEmpty }
            .distinctUntilChanged()
            .flatMapLatest { _ -> Observable<NowPlaying> in
                return fetchNowPlaying
            }
            .observeOn(MainScheduler.asyncInstance)
            .catchErrorJustReturn(NowPlaying.default)
            .share(replay: 1, scope: .whileConnected)
    }
    
    func startTimer() {
        timerDisposeBag = DisposeBag()
        
        let crcTimer = Observable<Int>.timer(0, period: 14, scheduler: queue)
        let crcTimerDisposable = crcTimer.asObservable()
            .flatMapLatest({ [weak self] _ -> Observable<String> in
                guard let strongSelf = self else { return Observable.empty() }
                return strongSelf.crcService.rx.request(.crc).mapString().asObservable()
            })
            .catchErrorJustReturn("")
            .bind(to: crc)
        
        timerDisposeBag?.insert(crcTimerDisposable)
    }
    
    func stopTimer() {
        timerDisposeBag = nil
    }
    
    func forceRefresh() {
        refresh.accept(())
    }

    func fetchNowPlaying() -> Observable<NowPlaying> {
        return self.nowPlayingService.rx.request(.nowPlaying)
            .observeOn(queue)
            .mapJSON()
            .map { NowPlaying(json: JSON($0)) }
            .asObservable()
            .catchErrorJustReturn(NowPlaying.default)
//            .flatMapLatest({ (nowPlaying) -> Observable<NowPlaying> in
//                return self.fetchLastFMInfo(with: nowPlaying)
//            })
    }

    // Currently Not Used
    fileprivate func fetchLastFMInfo(with nowPlaying: NowPlaying) -> Observable<NowPlaying> {
        let path: LastFMAPIService = .artistInfo(artist: nowPlaying.current.artist)
        return self.lastFMApiService.rx.request(path)
            .observeOn(queue)
            .mapJSON()
            .map { JSON($0) }
            .map { LastFMArtist(with: $0["artist"]) }
            .map { artist -> NowPlaying in
                let filtered = artist.images.filter { $0.size == "mega" || $0.size == "extralarge" }
                if let image = filtered.first {
                    return nowPlaying.update(with: image.url)
                }
                return nowPlaying
            }
            .asObservable()
            .catchErrorJustReturn(.empty)
    }

}
