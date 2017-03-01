//
//  ProducersService.swift
//  Offradio
//
//  Created by Dimitris C. on 01/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

final class ProducersBioService: APIService<[Producer]> {
    
    init() {
        let path: String = APIURL().with("producers")
        let request = APIRequest(apiPath: path, method: .get)
        super.init(request: request, parse: ProducerResponseParse())
    }
    
}

final class ProducerResponseParse: APIResponse<[Producer]> {
    
    override func toData(rawData data: JSON) -> [Producer] {
        var items: [Producer] = []
        items = data.map { Producer(with: $0.1) }
        return items
    }
    
}
