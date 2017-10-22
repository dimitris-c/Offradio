//
//  M3UService.swift
//  Offradio
//
//  Created by Dimitris C. on 22/10/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON
import Alamofire
import Moya

enum M3UService: TargetType {
    case streamUrl
}

extension M3UService {
    var baseURL: URL { return URL(string: OffradioStream().url)! }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        let now = Date().timeIntervalSince1970
        return .requestParameters(parameters:  ["noCache": String(now)], encoding: URLEncoding.queryString)
    }

    var path: String {
        return OffradioStream().path
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String : String]? {
        return nil
    }
}
