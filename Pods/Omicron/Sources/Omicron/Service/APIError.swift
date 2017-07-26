//
//  APIError.swift
//  Omicron
//
//  Created by Dimitris C. on 19/06/2017.
//  Copyright © 2017 Decimal. All rights reserved.
//

import Foundation

public enum APIError: Error {
    case error(String?)
    
    static public func parseError() -> Error {
        return APIError.error("Parse failed")
    }
}
