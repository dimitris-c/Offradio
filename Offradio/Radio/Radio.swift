//
//  Radio.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa

protocol RadioProtocol {
    var status: RadioState { get }
    var metadata: RadioMetadata { get }

    func setupRadio()

    func start()
    func stop()
    func toggleRadio()
}

protocol RadioMetadata {
    var nowPlaying: Observable<NowPlaying> { get }

    func startTimer()
    func stopTimer()
    func forceRefresh()

    func fetchNowPlaying() -> Observable<NowPlaying>
}

/**
 Deprecated RadioKit lib licence keys, only valid for 'gr.funkytaps.offradio' bundle
 */
struct RadioKitAuthenticationKeys {
    let key1: UInt32 = 0x943e3935
    let key2: UInt32 = 0xe19b0728
}

struct RadioStatus {
    var isPlaying: Bool = false
    var playbackWasInterrupted: Bool = false
}

enum RadioState: Int {
    case stopped
    case buffering
    case playing
    case interrupted
}
