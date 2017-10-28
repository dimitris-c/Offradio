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

    let nowPlaying: Variable<NowPlaying> = Variable<NowPlaying>(.empty)

    fileprivate let crc: Variable<String> = Variable<String>("")
    fileprivate let crcService = RxMoyaProvider<CRCService>()
    fileprivate let lastFMApiService = RxMoyaProvider<LastFMAPIService>()
    fileprivate let nowPlayingService = RxMoyaProvider<NowPlayingService>()
    fileprivate let nowPlayingParser = NowPlayingParse()

    fileprivate var timerDisposeBag: DisposeBag?

    func startTimer() {
        timerDisposeBag = DisposeBag()

        let crcTimer = Observable<Int>.timer(0, period: 14, scheduler: MainScheduler.instance)
        let crcTimerDisposable = crcTimer.asObservable()
            .flatMapLatest({ [weak self] _ -> Observable<String> in
                guard let strongSelf = self else { return Observable.empty() }
                return strongSelf.crcService.request(.crc).mapString().asObservable()
            })
            .catchErrorJustReturn("")
            .bind(to: crc)

        let crcDisposable = crc.asObservable()
            .skipWhile { $0.isEmpty }
            .distinctUntilChanged()
            .flatMapLatest { [weak self] _ -> Observable<NowPlaying> in
                guard let strongSelf = self else { return Observable.just(NowPlaying.default) }
                return strongSelf.fetchNowPlaying()
            }
            .catchErrorJustReturn(NowPlaying.default)
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

    func fetchNowPlaying() -> Observable<NowPlaying> {
        return self.nowPlayingService.request(.nowPlaying)
            .mapJSON()
            .map { NowPlaying(json: JSON($0)) }
            .asObservable()
            .catchErrorJustReturn(NowPlaying.default)
//        return self.nowPlayingService.call(with: .nowPlaying, parse: nowPlayingParser).catchErrorJustReturn(NowPlaying.default)
    }

    // Currently Not Used
//    fileprivate func fetchLastFMInfo(with nowPlaying: NowPlaying) -> Observable<NowPlaying> {
//        let path: LastFMAPIService = .artistInfo(artist: nowPlaying.current.artist)
//        return self.lastFMApiService.call(with: path, parse: LastFMAPIResponseParse()).map({ (artist) -> NowPlaying in
//            let filtered = artist.images.filter { $0.size == "mega" || $0.size == "large" }
//            if let image = filtered.first {
//                return nowPlaying.update(with: image.url)
//            }
//            return nowPlaying
//        })
//    }

}
