//
//  Radio.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import MediaPlayer
import RxSwift
import RxCocoa
import RxAlamofire

protocol RadioProtocol {
    func start()
    func stop()
}

struct RadioAuthenticationKeys {
    let key1: UInt32 = 0x943e3935
    let key2: UInt32 = 0xe19b0728
}

struct OffradioStream {
    let url: String = "http://www.offradio.gr/offradio.acc.m3u"
    static let radio: Offradio = Offradio()
}

struct RadioStatus {
    var isPlaying: Bool = false
    var playbackWasInterrupted: Bool = false
}

final class Offradio: RadioProtocol {
    let kit: RadioKit = RadioKit()
    private var status = RadioStatus()
    
    var nowPlaying: OffradioNowPlaying!
    
    init() {
        let keys = RadioAuthenticationKeys()
        
        self.kit.authenticateLibrary(withKey1: keys.key1, andKey2: keys.key2)
        self.setupRadio()
        
        self.nowPlaying = OffradioNowPlaying()
        self.nowPlaying.startTimer()
        
        if let version = self.kit.version() {
            Log.debug("RadioKit version: \(version)")
        }
    }
    
    final func setupRadio() {
        let offradioStream = OffradioStream()
        self.kit.setStreamUrl(offradioStream.url, isFile: false)
        self.kit.setPauseTimeout(250)
        self.kit.setBufferWaitTime(2)
        self.kit.stopStream()
        
    }
    
    final func start() {
        guard !status.isPlaying else { return }
        
        self.kit.startStream()
        
        status.isPlaying = true
    }
    
    final func stop() {
        guard status.isPlaying && kit.isAudioPlaying() else { return }
        
        self.kit.stopStream()
        
        status.isPlaying = false
    }
    
}

final class OffradioNowPlaying {
    fileprivate let disposeBag = DisposeBag()
    
    let nowPlaying: Variable<NowPlaying> = Variable<NowPlaying>(.empty)
    fileprivate let crc: Variable<String> = Variable<String>("")
    fileprivate let crcService: CRCService = CRCService()
    fileprivate let nowPlayingService: NowPlayingService = NowPlayingService()
    
    fileprivate var timerDisposeBag: DisposeBag?
    fileprivate var crcTimerDisposable: Disposable?
    
    func startTimer() {
        timerDisposeBag = DisposeBag()
        
        let crcTimer = Observable<Int>.timer(0, period: 14, scheduler: MainScheduler.instance)
        crcTimerDisposable = crcTimer.asObservable()
            .flatMapLatest({ [weak self] _ -> Observable<String> in
                guard let strongSelf = self else { return Observable.empty() }
                Log.debug("fetching")
                return strongSelf.fetchCRC()
            })
            .distinctUntilChanged()
            .bindTo(crc)
        
        crc.asObservable().flatMapLatest { _ -> Observable<NowPlaying> in
            return self.fetchNowPlaying()
        }.bindTo(nowPlaying)
        .addDisposableTo(disposeBag)
        
        timerDisposeBag?.insert(crcTimerDisposable!)
    }
    
    func stopTimer() {
        timerDisposeBag = nil
    }
    
    func fetchCRC() -> Observable<String> {
        return self.crcService.request.toAlamofire().rx.string()
    }
    
    func fetchNowPlaying() -> Observable<NowPlaying> {
        return self.nowPlayingService.rxCall()
    }
    
}
