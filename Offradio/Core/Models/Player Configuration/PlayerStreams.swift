//
//  PlayerStreams.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 24/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Foundation

struct PlayerStreams: Decodable {
    let lowBitrateAac: PlayerStreamQuality
    let highBitrateAac: PlayerStreamQuality
    let highBitrateMp3: PlayerStreamQuality
    let proxyStream: PlayerStreamQuality
    
    enum Keys: String, CodingKey {
        case lowBitrateAac
        case highBitrateAac
        case highBitrateMp3
        case highBitrateMp3Proxy
        case porxyStream
    }
    
    init(lowBitrateAac: PlayerStreamQuality,
         highBitrateAac: PlayerStreamQuality,
         highBitrateMp3: PlayerStreamQuality,
         proxyStream: PlayerStreamQuality) {
        self.lowBitrateAac = lowBitrateAac
        self.highBitrateAac = highBitrateAac
        self.highBitrateMp3 = highBitrateMp3
        self.proxyStream = proxyStream
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let lowBitrateAac = try container.decode(String.self, forKey: .lowBitrateAac)
        self.lowBitrateAac = .acc(type: .sd(url: lowBitrateAac))
        
        let highBitrateAac = try container.decode(String.self, forKey: .highBitrateAac)
        self.highBitrateAac = .acc(type: .hd(url: highBitrateAac))
        
        let highBitrateMp3 = try container.decode(String.self, forKey: .highBitrateMp3)
        self.highBitrateMp3 = .mp3(type: .hd(url: highBitrateMp3))
        
        let proxyStream = try container.decode(String.self, forKey: .highBitrateMp3Proxy)
        self.proxyStream = .proxy(url: proxyStream)
    }
}

extension PlayerStreams {
    func quality(for connectionType: NetConnectionType) -> PlayerStreamQuality {
        switch connectionType {
            case .cellular: return self.lowBitrateAac
            case .wifi: return self.highBitrateAac
            case .undetermined: return self.lowBitrateAac
                
        }
    }
    
    func quality(for userSettingsQuality: OffradioStreamQuality) -> PlayerStreamQuality {
        switch userSettingsQuality {
            case .hd: return self.highBitrateAac
            case .sd: return self.lowBitrateAac
        }
    }
}
