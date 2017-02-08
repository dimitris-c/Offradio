//
//  NowPlayingService.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

final class NowPlayingService: APIService {
    
    init() {
        let path: String = APIURL().with("nowplaying")
        let request = APIRequest(apiPath: path, method: .get)
        super.init(request: request, parse: NowPlayingParse())
    }
    
}

final class NowPlayingParse: ResponseParse {
    
    func toData(rawData data: JSON) -> Any {
        
        return data
    }
    
}
