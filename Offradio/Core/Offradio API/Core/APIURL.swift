//
//  APIBaseURL.swift
//
//  Created by Dimitris C. on 17/09/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

enum APIEnviroment {
    case old
    case new
    
    var baseUrl: String {
        switch self {
            case .old:
                return "http://www.offradio.gr"
            case .new:
                return "https://api.offradio.gr"
        }
    }
    
    var path: String {
        switch self {
            case .old:
                return "/mobile-api/"
            case .new:
                return "/mobile/v1"
        }
    }
}

public struct APIURL {
    
    let baseUrl: String
    private let api: String

    var apiPath: String {
        return "\(baseUrl)\(api)"
    }
    
    init(enviroment: APIEnviroment) {
        self.baseUrl = enviroment.baseUrl
        self.api = enviroment.path
    }

    func with(_ path: String) -> String {
        return self.baseUrl + api + path
    }
}
