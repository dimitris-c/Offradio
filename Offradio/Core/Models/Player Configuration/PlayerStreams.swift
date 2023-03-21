//
//  PlayerStreams.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 24/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Foundation

struct PlayerStreams: Decodable {
    let lowBitrate: PlayerStreamQuality
    let highBitrate: PlayerStreamQuality
    
    enum Keys: String, CodingKey {
        case lowBitrateAac
        case highBitrateAac
    }
    
    init(lowBitrate: PlayerStreamQuality,
         highBitrate: PlayerStreamQuality) {
        self.lowBitrate = lowBitrate
        self.highBitrate = highBitrate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let lowBitrateAac = try container.decode(String.self, forKey: .lowBitrateAac)
        self.lowBitrate = .acc(type: .sd(url: lowBitrateAac))
        
        let highBitrateAac = try container.decode(String.self, forKey: .highBitrateAac)
        self.highBitrate = .acc(type: .hd(url: highBitrateAac))
    }
}

extension PlayerStreams {
    func quality(for connectionType: NetConnectionType) -> PlayerStreamQuality {
        switch connectionType {
            case .cellular: return self.lowBitrate
            case .wifi: return self.highBitrate
            case .undetermined: return self.lowBitrate
                
        }
    }
    
    func quality(for userSettingsQuality: OffradioStreamQuality) -> PlayerStreamQuality {
        switch userSettingsQuality {
            case .hd: return self.highBitrate
            case .sd: return self.lowBitrate
        }
    }
}
