//
//  ScheduleService.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

final class ScheduleService: APIService {

    init() {
        let path: String = APIURL().with("schedule")
        let request = APIRequest(apiPath: path, method: .get)
        super.init(request: request, parse: APIResponse())
    }
    
}

final class ProducersBioService: APIService {

    init() {
        let path: String = APIURL().with("producers")
        let request = APIRequest(apiPath: path, method: .get)
        super.init(request: request, parse: APIResponse())
    }
    
}
