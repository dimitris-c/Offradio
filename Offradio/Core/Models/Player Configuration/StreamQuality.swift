//
//  StreamQuality.swift
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

enum PlayerStreamQuality {
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
