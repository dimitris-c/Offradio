//
//  PlayerConfiguration.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 24/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Foundation

enum StreamQualityType {
    case hd(url: String)
    case sd(url: String)
    
    var url: String {
        switch self {
            case .hd(let url):
                return url
            case .sd(let url):
                return url
        }
    }
}

enum PlayerStream {
    case acc(type: StreamQualityType)
    case mp3(type: StreamQualityType)
    case proxy(url: String)
    
    var url: String {
        switch self {
            case .acc(let type): return type.url
            case .mp3(let type): return type.url
            case .proxy(let url): return url
        }
    }

}

struct PlayerConfiguration: Decodable {
    let streams: PlayerStreams
}

struct PlayerStreams: Decodable {
    let lowBitrateAac: PlayerStream
    let highBitrateAac: PlayerStream
    let lowBitrateMp3: PlayerStream
    let highBitrateMp3: PlayerStream
    let proxyStream: PlayerStream
    
    enum Keys: String, CodingKey {
        case lowBitrateAac
        case highBitrateAac
        case lowBitrateMp3
        case highBitrateMp3
        case highBitrateMp3Proxy
        case porxyStream
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let lowBitrateAac = try container.decode(String.self, forKey: .lowBitrateAac)
        self.lowBitrateAac = .acc(type: .sd(url: lowBitrateAac))
        
        let highBitrateAac = try container.decode(String.self, forKey: .highBitrateAac)
        self.highBitrateAac = .acc(type: .hd(url: highBitrateAac))
        
        let lowBitrateMp3 = try container.decode(String.self, forKey: .lowBitrateMp3)
        self.lowBitrateMp3 = .mp3(type: .sd(url: lowBitrateMp3))
        
        let highBitrateMp3 = try container.decode(String.self, forKey: .highBitrateMp3)
        self.highBitrateMp3 = .mp3(type: .hd(url: highBitrateMp3))
        
        let proxyStream = try container.decode(String.self, forKey: .highBitrateMp3Proxy)
        self.proxyStream = .proxy(url: proxyStream)
        
    }
}
