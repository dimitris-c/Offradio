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
        return decoder
    }()
}
