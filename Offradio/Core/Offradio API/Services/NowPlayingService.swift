//
//  NowPlayingService.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Alamofire
import Moya

enum NowPlayingService: TargetType {
    case nowPlaying
}

extension NowPlayingService {
    var baseURL: URL { return URL(string: APIURL(enviroment: .new).apiPath)! }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        let now = Date().timeIntervalSince1970
        return .requestParameters(parameters: ["noCache": String(now)], encoding: URLEncoding.queryString)
    }

    var path: String {
        return "now-playing"
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String : String]? {
        return nil
    }

}
