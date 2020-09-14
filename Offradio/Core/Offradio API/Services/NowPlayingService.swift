//
//  NowPlayingService.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON
import Alamofire
import Moya

enum NowPlayingService: TargetType {
    case nowPlaying
}

extension NowPlayingService {
    var baseURL: URL { return URL(string: APIURL(enviroment: .old).apiPath)! }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        let now = Date().timeIntervalSince1970
        return .requestParameters(parameters: ["noCache": String(now)], encoding: URLEncoding.queryString)
    }

    var path: String {
        return "nowplaying"
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String : String]? {
        return nil
    }

}

final class NowPlayingParse {

    func toData(rawData data: JSON) -> NowPlaying {
        return NowPlaying(json: data)
    }

}

enum CRCService: TargetType {
    case crc
}

extension CRCService {
    var baseURL: URL { return URL(string: APIURL(enviroment: .old).baseUrl)! }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        let now = Date().timeIntervalSince1970
        return .requestParameters(parameters:  ["noCache": String(now)], encoding: URLEncoding.queryString)
    }

    var path: String {
        return "mob_player.crc"
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String : String]? {
        return nil
    }
}

final class CRCResponse {
    func toData(rawData data: JSON) -> String? {
        return data.stringValue
    }
}
