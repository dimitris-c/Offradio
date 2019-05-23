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

enum MetadataTrigger: Equatable {
    case crc(value: String)
    case refresh
    case none
}

final class OffradioMetadata: RadioMetadata {
    fileprivate let disposeBag = DisposeBag()
    
    private let queue = ConcurrentDispatchQueueScheduler(qos: .background)
    let nowPlaying: Observable<NowPlaying>
    
    let currentTrack = BehaviorRelay<CurrentTrack>(value: .default)
    
    fileprivate let refresh = PublishRelay<MetadataTrigger>()
    fileprivate let crcTrigger = PublishRelay<MetadataTrigger>()
    fileprivate var crcTimerDisposable: Disposable?
    
    fileprivate let crcService = MoyaProvider<CRCService>()
    fileprivate let lastFMApiService = MoyaProvider<LastFMAPIService>()
    fileprivate let nowPlayingService = MoyaProvider<NowPlayingService>()
    
    public init() {
        
        let fetchNowPlaying = self.nowPlayingService.rx.request(.nowPlaying)
            .observeOn(queue)
            .mapJSON()
            .map { NowPlaying(json: JSON($0)) }
            .asObservable()
            .catchErrorJustReturn(NowPlaying.default)
        
        nowPlaying = Observable.merge(crcTrigger.asObservable(), refresh.asObservable())
            .skipWhile { $0 == .none }
            .distinctUntilChanged()
            .flatMapLatest { _ -> Observable<NowPlaying> in
                return fetchNowPlaying
            }
            .observeOn(MainScheduler.asyncInstance)
            .catchErrorJustReturn(NowPlaying.default)
            .share(replay: 1, scope: .whileConnected)
        
        nowPlaying
            .map { $0.current }
            .bind(to: currentTrack)
            .disposed(by: disposeBag)
    }
    
    func startTimer() {
        stopTimer()
        let crcTimer = Observable<Int>.timer(0, period: 14, scheduler: queue)
        crcTimerDisposable = crcTimer.asObservable()
            .flatMapLatest({ [weak self] _ -> Observable<MetadataTrigger> in
                guard let strongSelf = self else { return Observable.empty() }
                return strongSelf.crcService.rx.request(.crc)
                    .mapString()
                    .asObservable()
                    .map { MetadataTrigger.crc(value: $0) }
            })
            .catchErrorJustReturn(.none)
            .bind(to: crcTrigger)
    }
    
    func stopTimer() {
        crcTimerDisposable?.dispose()
        crcTimerDisposable = nil
    }
    
    func forceRefresh() {
        refresh.accept(.refresh)
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
