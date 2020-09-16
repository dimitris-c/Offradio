//
//  NowPlayingSocketService.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 16/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import RxSwift
import RxCocoa

final class NowPlayingSocketService {
    
    let builder: OffradioWebsocketBuilder
    let websocket: OffradioWebSocket
    
    init(builder: OffradioWebsocketBuilder, url: String) {
        self.builder = builder
        self.websocket = builder.websocket(url: url)
    }
    
    func nowPlayingUpdates() -> Driver<NowPlaying> {
        self.websocket.connect()
            .flatMapLatest { [weak self] status -> Driver<NowPlaying> in
                guard let self = self else { return .empty() }
                switch status {
                    case .connected:
                        return self.read()
                    case .disconnected:
                        return .empty()
                }
            }.asDriver(onErrorDriveWith: .empty())
    }
    
    
    private func read() -> Driver<NowPlaying> {
        websocket.read.flatMap { raw in
            if let decoded = Decoders.defaultJSONDecoder.decode(json: raw, type: NowPlaying.self) {
                return .just(decoded)
            }
            return .empty()
        }
    }
}
