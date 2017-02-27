//
//  MockAPIService.swift
//  JLTest
//
//  Created by Dimitris C. on 26/02/2017.
//  Copyright © 2017 Decimal. All rights reserved.
//

import Alamofire
import SwiftyJSON
@testable import Offradio

class MockJSONAPIService: APIService<JSON> {
    var mockData: JSON!
    
    init(with mockData: JSON) {
        self.mockData = mockData
        let apiRequest = APIRequest(apiPath: "https://httpbin.org")
        super.init(request: apiRequest, parse: JSONResponse())
    }
    
    @discardableResult
    override func call(_ completion: @escaping (Bool, ModelResult<JSON>, [AnyHashable : Any]?) -> Void) -> Request {
        let data = self.parse.toData(rawData: self.mockData)
        completion(true, ModelResult<JSON>(value: data, error: nil), nil)
        return self.request.toAlamofire()
    }

}
