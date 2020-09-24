//
//  APIBaseURL.swift
//
//  Created by Dimitris C. on 17/09/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

enum APIEnviroment {
    case new
    
    var baseUrl: String {
        switch self {
            case .new:
                return "https://api.offradio.gr"
        }
    }
    
    var path: String {
        switch self {
            case .new:
                return "/mobile/v1"
        }
    }
    
    var socket: String {
        switch self {
            case .new:
                return "wss://live.offradio.gr/socket.io/"
        }
    }
}

public struct APIURL {
    
    let baseUrl: String
    private let api: String

    var apiPath: String {
        return "\(baseUrl)\(api)"
    }
    
    let socket: String
    
    init(enviroment: APIEnviroment) {
        self.baseUrl = enviroment.baseUrl
        self.api = enviroment.path
        self.socket = enviroment.socket
    }

    func with(_ path: String) -> String {
        return self.baseUrl + api + path
    }
    
}
