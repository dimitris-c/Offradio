//
//  ProducersService.swift
//  Offradio
//
//  Created by Dimitris C. on 01/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON
import Alamofire
import Moya

enum ProducersBioService: TargetType {
    case producers
}

extension ProducersBioService {
    var baseURL: URL { return URL(string: APIURL(enviroment: .old).apiPath)! }

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "producers"
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

struct ProducerResponseParse {

    func toData(rawData data: JSON) -> [Producer] {
        var items: [Producer] = []
        items = data.map { Producer(with: $0.1) }
        return items
    }

}
