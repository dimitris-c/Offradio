//
//  NowPlayingService.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

final class NowPlayingService: APIService<NowPlaying> {
    
    init() {
        let path: String = APIURL().with("nowplaying")
        let request = APIRequest(apiPath: path, method: .get)
        super.init(request: request, parse: NowPlayingParse())
    }
    
}

final class NowPlayingParse: APIResponse<NowPlaying> {
    
    override func toData(rawData data: JSON) -> NowPlaying {
        return NowPlaying(json: data)
    }
    
}

final class CRCService: APIService<String> {
    
    init() {
        let path: String = APIURL().baseUrl + "/mob_player.crc?noCache=\(Date().timeIntervalSince1970)"
        let request = APIRequest(apiPath: path, method: .get)
        super.init(request: request, parse: CRCResponse())
    }
    
}

final class CRCResponse: APIResponse<String> {
    override func toData(rawData data: JSON) -> String? {
        return data.stringValue
    }
}
