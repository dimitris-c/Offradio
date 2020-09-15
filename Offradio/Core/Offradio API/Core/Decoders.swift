//
//  Decoders.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 14/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Foundation

struct Decoders {
    static var defaultJSONDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(Formatters.playlistFormatter)
        return decoder
    }()
    
    static var defaultKeysJSONDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.useDefaultKeys
        decoder.dateDecodingStrategy = .formatted(Formatters.playlistFormatter)
        return decoder
    }()
}
