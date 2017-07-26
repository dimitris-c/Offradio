//
//  ScheduleService.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON
import Omicron
import Alamofire

enum ScheduleService: Service {
    case schedule
}

extension ScheduleService {
    var baseURL: URL { return URL(string: APIURL().apiPath)! }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "schedule"
    }
    
    var params: RequestParameters {
        return RequestParameters.default
    }

}

final class ScheduleResponseParse: APIResponse<Schedule> {
    
    override func toData(rawData data: JSON) -> Schedule {        
        return Schedule(with: data)
    }
    
}
