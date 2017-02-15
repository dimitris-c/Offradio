//
//  PlaylistService.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift

final class PlaylistService: APIService {
    
    var page: Int = 0
    
    init() {
        let path: String = APIURL().with("playlist")
        let request = APIRequest(apiPath: path, method: .get)
        super.init(request: request, parse: PlaylistResponseParse())
    }
    
    init(withPage page: Int) {
        let path: String = APIURL().with("playlist")
        let params: Parameters = ["page": String(page)]
        let parameters = RequestParameters(parameters: params, encoding: URLEncoding.default)
        let request = APIRequest(apiPath: path, method: .get, parameters: parameters)
        super.init(request: request, parse: PlaylistResponseParse())
    }
    
    func with(page: Int) -> APIService {
        return PlaylistService(withPage: page)
    }
    
}

final class PlaylistResponseParse: ResponseParse {
    
    func toData(rawData data: JSON) -> Any {
        var items: [PlaylistSong] = []
        items = data["playlist"].arrayValue.map { PlaylistSong(with: $0) }
        return items
    }
    
}

