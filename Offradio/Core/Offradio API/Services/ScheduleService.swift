//
//  ScheduleService.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

final class ScheduleService: APIService<[ScheduleItem]> {

    init() {
        let path: String = APIURL().with("schedule")
        let request = APIRequest(apiPath: path, method: .get)
        super.init(request: request, parse: ScheduleResponseParse())
    }
    
}

final class ProducersBioService: APIService<[Producer]> {

    init() {
        let path: String = APIURL().with("producers")
        let request = APIRequest(apiPath: path, method: .get)
        super.init(request: request, parse: ProducerResponseParse())
    }
    
}

final class ScheduleResponseParse: APIResponse<[ScheduleItem]> {
    
    override func toData(rawData data: JSON) -> [ScheduleItem] {
        var items: [ScheduleItem] = []
        items = data.arrayValue.dropFirst().map { ScheduleItem(with: $0) }
        return items
    }
    
}

final class ProducerResponseParse: APIResponse<[Producer]> {
    
    override func toData(rawData data: JSON) -> [Producer] {
        var items: [Producer] = []
        items = data.map { Producer(with: $0.1) }
        return items
    }
    
}
