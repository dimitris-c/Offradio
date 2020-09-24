//
//  OffradioNetworkService.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 24/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Alamofire
import Moya

enum OffradioNetworkAPI: TargetType {
    case configuration
    case nowPlaying
    case playlist(page: Int)
    case schedule
    case producers
}

extension OffradioNetworkAPI {
    var baseURL: URL { return URL(string: APIURL(enviroment: .new).apiPath)! }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
            case .configuration,
                 .schedule,
                 .producers,
                 .nowPlaying:
                return .requestPlain
            case .playlist(let page):
                return .requestParameters(parameters: ["page": String(page)], encoding: URLEncoding.default)
        }
    }

    var path: String {
        switch self {
            case .configuration: return "player-setup"
            case .nowPlaying: return "now-playing"
            case .playlist: return "playlist"
            case .schedule: return "schedule"
            case .producers: return "producers"
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String : String]? {
        return nil
    }

}
