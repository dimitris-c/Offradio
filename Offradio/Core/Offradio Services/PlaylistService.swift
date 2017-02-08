//
//  PlaylistService.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Alamofire

final class PlaylistService: APIService {
    
    init() {
        let path: String = APIURL().with("playlist")
        let request = APIRequest(apiPath: path, method: .get)
        super.init(request: request, parse: APIResponse())
    }
    
    init(with page: String) {
        let path: String = APIURL().with("playlist")
        let params: Parameters = ["page": page]
        let parameters = RequestParameters(parameters: params, encoding: URLEncoding.default)
        let request = APIRequest(apiPath: path, method: .get, parameters: parameters)
        super.init(request: request, parse: APIResponse())
    }
}
