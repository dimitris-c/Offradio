//
//  ProducersService.swift
//  Offradio
//
//  Created by Dimitris C. on 01/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON
import Alamofire
import Omicron

enum ProducersBioService: Service {
    case producers
}

extension ProducersBioService {
    var baseURL: URL { return URL(string: APIURL().apiPath)! }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "producers"
    }
    
    var params: RequestParameters {
        return RequestParameters.default
    }
    
}

final class ProducerResponseParse: APIResponse<[Producer]> {
    
    override func toData(rawData data: JSON) -> [Producer] {
        var items: [Producer] = []
        items = data.map { Producer(with: $0.1) }
        return items
    }
    
}
