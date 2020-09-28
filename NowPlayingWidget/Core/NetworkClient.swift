//
//  NetworkClient.swift
//  NowPlayingWidgetExtension
//
//  Created by Dimitrios Chatzieleftheriou on 25/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Foundation
import Combine

enum RequestError: Error {
    case sessionError(error: Error)
    case unknown
}

final class NetworkClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func request(url: String) -> AnyPublisher<Data, RequestError> {
        guard let url = URL(string: url) else {
            return Empty(outputType: Data.self, failureType: RequestError.self).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
                .map(\.data)
                .mapError { error -> RequestError in
                    return RequestError.sessionError(error: error)
                }
                .eraseToAnyPublisher()
    }
    
}

final class OffradioAPIClient {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getNowPlaying() -> AnyPublisher<CurrentTrack, RequestError> {
        let urlPath = APIURL(enviroment: .production).with("/now-playing")
        return networkClient.request(url: urlPath)
            .decode(type: NowPlaying.self, decoder: Decoders.defaultJSONDecoder)
            .map(\.track)
            .mapError { error -> RequestError in
                return RequestError.sessionError(error: error)
            }
            .eraseToAnyPublisher()
    }
    
    func getPlaylist() -> AnyPublisher<[Song], RequestError> {
        let urlPath = APIURL(enviroment: .production).with("/playlist")
        return networkClient.request(url: urlPath)
            .decode(type: [Song].self, decoder: Decoders.defaultKeysJSONDecoder)
            .print()
            .mapError { error -> RequestError in
                return RequestError.sessionError(error: error)
            }
            .eraseToAnyPublisher()
    }
}
