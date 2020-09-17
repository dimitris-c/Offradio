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
    case connected
    case disconnected
    
    static func from(socketIOStatus: SocketIOStatus) -> WebSocketStatus {
        switch socketIOStatus {
            case .connected:
                return .connected
            case .disconnected:
                return .disconnected
            case .connecting:
                return .connected
            case .notConnected:
                return .disconnected
        }
    }
}

protocol OffradioWebSocket {
    func connect() -> Observable<WebSocketStatus>
    func disconnect() -> Observable<WebSocketStatus>
    func write(data: Data) -> Driver<Void>
    var read: Driver<String> { get }
}

class OffradioWebSocketService: OffradioWebSocket {
    
    private let socketManager: SocketManager
    private let socket: SocketIOClient
    
    init(urlRequest: URLRequest) {
        self.socketManager = SocketManager(socketURL: urlRequest.url!)
        self.socket = socketManager.defaultSocket
    }
    
    var read: Driver<String> {
        return Observable<String>.create { [socket] observer -> Disposable in
            socket.on("onair:nowplaying") { (items, _) in
                guard let raw = items.first else { return }
                let json = String(describing: raw)
                observer.on(.next(json))
            }
            return Disposables.create()
        }.asDriver(onErrorDriveWith: .empty())
    }
    
    /// not yet implemented
    func write(data: Data) -> Driver<Void> {
        return .empty()
    }
    
    func connect() -> Observable<WebSocketStatus> {
        return Observable<WebSocketStatus>.create({ [socket, socketManager] (observer) -> Disposable in
            socket.on(clientEvent: .statusChange) { (statuses, ack) in
                if let status = statuses[0] as? SocketIOStatus {
                    observer.onNext(WebSocketStatus.from(socketIOStatus: status))
                }
            }
            socketManager.connect()
            return Disposables.create {
                socket.disconnect()
            }
        })
    }
    
    func disconnect() -> Observable<WebSocketStatus> {
        return Observable<WebSocketStatus>.create({ [socket, socketManager] (observer) -> Disposable in
            socket.on(clientEvent: .statusChange) { (statuses, ack) in
                if let status = statuses[0] as? SocketIOStatus {
                    observer.onNext(WebSocketStatus.from(socketIOStatus: status))
                }
            }
            socketManager.disconnect()
            return Disposables.create()
        })
    }
}
