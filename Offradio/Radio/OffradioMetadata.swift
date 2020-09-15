//
//  OffradioMetadata.swift
//  Offradio
//
//  Created by Dimitris C. on 27/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//
import RxSwift
import RxCocoa
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
    let nowPlaying: Observable<NowPlaying_v2>
    
    let currentTrack = BehaviorRelay<CurrentTrack_v2>(value: .default)
    
    fileprivate let refresh = PublishRelay<MetadataTrigger>()
    fileprivate let crcTrigger = PublishRelay<MetadataTrigger>()
    fileprivate var crcTimerDisposable: Disposable?
    
    fileprivate let crcService = MoyaProvider<CRCService>()
    fileprivate let lastFMApiService = MoyaProvider<LastFMAPIService>()
    fileprivate let nowPlayingService = MoyaProvider<NowPlayingService>()
    
    public init() {
        
        let fetchNowPlaying = self.nowPlayingService.rx.request(.nowPlaying)
            .observeOn(queue)
            .map(NowPlaying_v2.self, atKeyPath: nil, using: Decoders.defaultJSONDecoder, failsOnEmptyData: false)
            .asObservable()
            .catchErrorJustReturn(NowPlaying_v2.default)
        
        nowPlaying = refresh.asObservable()
            .distinctUntilChanged()
            .flatMapLatest { _ -> Observable<NowPlaying_v2> in
                return fetchNowPlaying
            }
            .observeOn(MainScheduler.asyncInstance)
            .catchErrorJustReturn(NowPlaying_v2.default)
            .share(replay: 1, scope: .whileConnected)
        
        nowPlaying
            .map { $0.track }
            .bind(to: currentTrack)
            .disposed(by: disposeBag)
    }
    
    func startTimer() {
        stopTimer()
        let crcTimer = Observable<Int>.timer(.seconds(0), period: .seconds(20), scheduler: queue)
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

    func fetchNowPlaying() -> Observable<NowPlaying_v2> {
        return self.nowPlayingService.rx.request(.nowPlaying)
            .observeOn(queue)
            .map(NowPlaying_v2.self, atKeyPath: nil, using: Decoders.defaultJSONDecoder, failsOnEmptyData: false)
            .asObservable()
            .catchErrorJustReturn(NowPlaying_v2.default)
    }

}
