//
//  APIResponse.swift
//
//  Created by Dimitris C. on 17/09/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import Foundation
import SwiftyJSON

/// A Protocol that API response class should conform to.
public protocol ResponseParse {
    associatedtype Model
    /**
     Converts the passed data of `JSON` to the specified model
     
     - parameter data: The `JSON` data to be converted.
     
     - returns: The `Model` after the convertion. Can be `nil` if the conversion fails.
     
    */
    func toData(rawData data: JSON) -> Model?
}

/**
 A default implementation of a `ResponseParse` that takes a generic argument as the output of the parse result.
 This is meant to be subclassed.
 */
open class APIResponse<T>: ResponseParse {
    public init() { }
    // default implemention does nothing and will return nil
    open func toData(rawData data: JSON) -> T? {
        return data as? T
    }
    
}

/// A convenience class that outputs the passed `JSON` as is, without any conversion.
final public class JSONResponse: APIResponse<JSON> {
    override public func toData(rawData data: JSON) -> JSON {
        return data
    }
}
