//
//  JSONDecoder+DecodeString.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 16/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Foundation

extension JSONDecoder {
    public func decode<T: Decodable>(json: String, type: T.Type) -> T? {
        if let data = json.data(using: .utf8) {
            if let decoded = try? self.decode(type, from: data) {
                return decoded
            }
            return nil
        }
        return nil
    }
}
