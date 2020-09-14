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
import Moya

enum PlaylistService: TargetType {
    case playlist(page: Int)
}

extension PlaylistService {
    var baseURL: URL { return URL(string: APIURL(enviroment: .new).apiPath)! }

    var method: Moya.Method {
        return .get
    }

    var path: String {
        return "playlist"
    }

    var task: Task {
        switch self {
        case .playlist(let page):
            let now = Date().unixTimestamp
            return .requestParameters(parameters: ["page": String(page), "noCache": String(now)], encoding: URLEncoding.default)
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String : String]? {
        return nil
    }

}

final class PlaylistResponseParse {

 func toData(rawData data: JSON) -> [PlaylistSong] {
        var items: [PlaylistSong] = []
        items = data["playlist"].arrayValue.map { PlaylistSong(with: $0) }
        return items
    }

}
