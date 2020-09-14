//
//  ScheduleService.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON
import Moya
import Alamofire

enum ScheduleService: TargetType {
    case schedule
}

extension ScheduleService {
    var baseURL: URL { return URL(string: APIURL(enviroment: .new).apiPath)! }

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "schedule"
    }

    var task: Task {
        return .requestPlain
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String : String]? {
        return nil
    }
}
