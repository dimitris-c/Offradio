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
import Omicron

enum PlaylistService: Service {
    case playlist(page: Int)
}

extension PlaylistService {
    var baseURL: URL { return URL(string: APIURL().apiPath)! }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "playlist"
    }
    
    var params: RequestParameters {
        switch self {
        case .playlist(let page):
            let now = Date().unixTimestamp
            let data: Parameters = ["page": String(page), "noCache": String(now)]
            let parameters = RequestParameters(parameters: data, encoding: URLEncoding.default)
            return parameters
        }
    }
        
}

final class PlaylistResponseParse: APIResponse<[PlaylistSong]> {
    
    override func toData(rawData data: JSON) -> [PlaylistSong] {
        var items: [PlaylistSong] = []
        items = data["playlist"].arrayValue.map { PlaylistSong(with: $0) }
        return items
    }
    
}

