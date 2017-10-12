//
//  APIBaseURL.swift
//
//  Created by Dimitris C. on 17/09/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

public struct APIURL {

    let baseUrl = "http://www.offradio.gr"

    fileprivate let api = "/mobile-api/"

    var apiPath: String {
        return "\(baseUrl)\(api)"
    }

    func with(_ path: String) -> String {
        return self.baseUrl + api + path
    }
}
