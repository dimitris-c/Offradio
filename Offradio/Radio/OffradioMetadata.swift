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
    
    fileprivate let networkService: OffradioNetworkService
    
    private var nowPlayingSocketDisposable: Disposable?
    private let nowPlayinSocketService: NowPlayingSocketService
    
    public init(networkService: OffradioNetworkService) {
        self.networkService = networkService
        self.nowPlayinSocketService = NowPlayingSocketService(builder: OffradioWebsocketBuilder(),
                                                              url: APIURL(enviroment: .new).socket)
        
        let fetchNowPlaying = self.networkService.rx.request(.nowPlaying)
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
            .do(onNext: { _ in
                if #available(iOS 14.0, *) {
                    WidgerUpdater().updateTimeline(for: .nowplaying)
                } else {
                }
            })
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
        return self.networkService.rx.request(.nowPlaying)
            .observeOn(queue)
            .map(NowPlaying.self, atKeyPath: nil, using: Decoders.defaultJSONDecoder, failsOnEmptyData: false)
            .asObservable()
            .catchErrorJustReturn(NowPlaying.default)
    }
    
}
