//
//  NowPlayingService.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON
import Alamofire
import Omicron

enum NowPlayingService: Service {
    case nowPlaying
}

extension NowPlayingService {
    var baseURL: URL { return URL(string: APIURL().apiPath)! }
    
    var method: HTTPMethod {
        return .get
    }
    
    var params: RequestParameters {
        let now = Date().timeIntervalSince1970
        return RequestParameters(parameters: ["noCache": String(now)])
    }
    
    var path: String {
        return "nowplaying"
    }
}

final class NowPlayingParse: APIResponse<NowPlaying> {
    
    override func toData(rawData data: JSON) -> NowPlaying {
        return NowPlaying(json: data)
    }
    
}

enum CRCService: Service {
    case crc
}

extension CRCService {
    var baseURL: URL { return URL(string: APIURL().baseUrl)! }
    
    var method: HTTPMethod {
        return .get
    }
    
    var params: RequestParameters {
        let now = Date().timeIntervalSince1970
        return RequestParameters(parameters: ["noCache": String(now)])
    }
    
    var path: String {
        return "mob_player.crc"
    }
}

final class CRCResponse: APIResponse<String> {
    override func toData(rawData data: JSON) -> String? {
        return data.stringValue
    }
}
