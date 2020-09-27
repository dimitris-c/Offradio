//
//  WebSocketService.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 16/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import RxSwift
import RxCocoa
import Starscream
import SocketIO

class OffradioWebsocketBuilder {
    func websocket(url: String) -> OffradioWebSocket {
        let urlRequest = URLRequest(url: URL(string: url)!)
        return OffradioWebSocketService(urlRequest: urlRequest)
    }
}

enum WebsocketError: Equatable {
    case error(Error?)
    
    var description: String {
        switch self {
            case .error(let error):
                return error?.localizedDescription ?? "Generic socket error"
        }
    }
    
    static func == (lhs: WebsocketError, rhs: WebsocketError) -> Bool {
        switch (lhs, rhs) {
            case (.error, .error):
                return true
        }
    }
    
}

enum WebSocketStatus: Equatable {
    case connecting
    case connected
    case disconnected
    
    static func from(socketIOStatus: SocketIOStatus) -> WebSocketStatus {
        switch socketIOStatus {
            case .connected:
                return .connected
            case .disconnected:
                return .disconnected
            case .connecting:
                return .connecting
            case .notConnected:
                return .disconnected
        }
    }
}

protocol OffradioWebSocket {
    func connect() -> Observable<WebSocketStatus>
    func disconnect() -> Observable<WebSocketStatus>
    func write(data: Data) -> Driver<Void>
    var read: Observable<Data> { get }
}

class OffradioWebSocketService: OffradioWebSocket {
    
    private let socketManager: SocketManager
    private let socket: SocketIOClient
    
    init(urlRequest: URLRequest) {
        self.socketManager = SocketManager(socketURL: urlRequest.url!)
        self.socket = socketManager.defaultSocket
    }
    
    var read: Observable<Data> {
        return Observable<Data>.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.socket.on("onair:nowplaying") { (items, _) in
                guard let raw = items.first else { return }
                do {
                    let json = try JSONSerialization.data(withJSONObject: raw, options: .fragmentsAllowed)
                    observer.on(.next(json))
                } catch {
                    print("Error \(error.localizedDescription)")
                }
            }
            return Disposables.create()
        }
    }
    
    /// not yet implemented
    func write(data: Data) -> Driver<Void> {
        return .empty()
    }
    
    func connect() -> Observable<WebSocketStatus> {
        return Observable<WebSocketStatus>.create({ [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.socket.on(clientEvent: .statusChange) { (statuses, ack) in
                if let status = statuses.first as? SocketIOStatus {
                    observer.onNext(WebSocketStatus.from(socketIOStatus: status))
                }
            }
            self.socket.connect()
            return Disposables.create {
                self.socket.removeAllHandlers()
                self.socket.disconnect()
            }
        })
    }
    
    func disconnect() -> Observable<WebSocketStatus> {
        return Observable<WebSocketStatus>.create({ [socket] (observer) -> Disposable in
            socket.on(clientEvent: .disconnect) { (statuses, ack) in
                if let status = statuses.first as? SocketIOStatus {
                    observer.onNext(WebSocketStatus.from(socketIOStatus: status))
                }
            }
            socket.disconnect()
            return Disposables.create()
        })
    }
}
