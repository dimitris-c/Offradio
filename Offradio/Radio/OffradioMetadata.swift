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
    
    fileprivate let nowPlayingService = MoyaProvider<NowPlayingService>()
    
    private var nowPlayingSocketDisposable: Disposable?
    private let nowPlayinSocketService: NowPlayingSocketService
    
    public init() {
        
        self.nowPlayinSocketService = NowPlayingSocketService(builder: OffradioWebsocketBuilder(),
                                                              url: APIURL(enviroment: .new).socket)
        
        let fetchNowPlaying = self.nowPlayingService.rx.request(.nowPlaying)
            .observeOn(queue)
            .map(NowPlaying.self, atKeyPath: nil, using: Decoders.defaultJSONDecoder, failsOnEmptyData: false)
            .asObservable()
            .catchErrorJustReturn(NowPlaying.default)
        
        nowPlaying = refresh.asObservable()
            .flatMapLatest { _ -> Observable<NowPlaying> in
                return fetchNowPlaying
            }
            .observeOn(MainScheduler.asyncInstance)
            .catchErrorJustReturn(NowPlaying.default)
            .share(replay: 1, scope: .whileConnected)
        
        nowPlaying
            .map { $0.track }
            .bind(to: currentTrack)
            .disposed(by: disposeBag)
        
    }
    
    func openSocket() {
        closeSocket()
        nowPlayingSocketDisposable = nowPlayinSocketService.nowPlayingUpdates()
            .distinctUntilChanged()
            .map { $0.track }
            .drive(currentTrack)
    }
    
    func closeSocket() {
        nowPlayingSocketDisposable?.dispose()
        nowPlayingSocketDisposable = nil
    }
    
    func forceRefresh() {
        refresh.accept(.refresh)
    }
    
    func fetchNowPlaying() -> Observable<NowPlaying> {
        return self.nowPlayingService.rx.request(.nowPlaying)
            .observeOn(queue)
            .map(NowPlaying.self, atKeyPath: nil, using: Decoders.defaultJSONDecoder, failsOnEmptyData: false)
            .asObservable()
            .catchErrorJustReturn(NowPlaying.default)
    }
    
}
