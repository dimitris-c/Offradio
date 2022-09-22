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
    
    func nowPlayingUpdates() -> Observable<NowPlaying> {
        self.websocket.connect()
            .flatMap { [weak self] status -> Observable<NowPlaying> in
                guard let self = self else { return .empty() }
                switch status {
                    case .connecting:
                        return .empty()
                    case .connected:
                        return self.read()
                    case .disconnected:
                        return .just(.default)
                }
            }
    }
    
    
    func read() -> Observable<NowPlaying> {
        websocket.read.map { data in
            if let decoded = try? Decoders.defaultJSONDecoder.decode(NowPlaying.self, from: data) {
                return decoded
            }
            return NowPlaying.default
        }.share(replay: 1, scope: .whileConnected)
    }
    
    private func disconnect() -> Observable<WebSocketStatus>  {
        websocket.disconnect()
    }
}
