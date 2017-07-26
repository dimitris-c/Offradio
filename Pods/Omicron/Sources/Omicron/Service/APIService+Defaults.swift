//
//  APIService.swift
//
//  Created by Dimitris C. on 16/09/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public typealias CompletionBlock<Model> = (_ success: Bool, _ result: Result<Model>, _ response: HTTPURLResponse?) -> Void

internal struct Queue {
    fileprivate static let queueLabel: String = "com.decimal.services.api-response-queue"
    static let network: DispatchQueue = DispatchQueue(label: queueLabel,
                                                      attributes: DispatchQueue.Attributes.concurrent)
}

internal final class Log {
    final class func debug(_ message:String) {
        #if DEBUG
            print(message)
        #else
        #endif
    }
}

/**
 A generic `APIService` which parses the response and returns the specifed `Model`
 */
public extension APIService {
    
    /**
     Executes the call of the specified `APIRequest` with the passed parse object.
     
     - parameter completion: A completion block to handle the response
     
     - returns: The Alamofire `Request` that can be used to cancel the request
     */
    @discardableResult
    public func call<Model>(request: APIRequest, parse: APIResponse<Model>, _ completion: @escaping CompletionBlock<Model>) -> Request {
        let handler: (DataResponse<Any>) -> Void = { [request, parse, completion] (response) in
            if let statusCode = response.response?.statusCode {
                Log.debug("Request: \(request.apiPath), status code: \(statusCode)")
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var modelResult: Result<Model> = .failure(APIError.parseError())
                if let data = parse.toData(rawData: json) {
                    modelResult = .success(data)
                }
                DispatchQueue.main.async {
                    completion(true, modelResult, response.response)
                }
                break
            case .failure(let error):
                if let data = response.data {
                    let json = JSON(data: data)
                    Log.debug("Server Response: \(json)")
                    Log.debug("Error: \(error.localizedDescription)")
                }
                let result: Result<Model> = .failure(error)
                DispatchQueue.main.async {
                    completion(false, result, response.response)
                }
                break
            }
        }
        Log.debug("Requesting: \(request.apiPath)")
        return request.toAlamofire().validate().responseJSON(queue: Queue.network, completionHandler: handler)
    }
    
    /**
     A convenient method to which outputs its response as JSON as is.
    */
    @discardableResult
    public func callJSON(request: APIRequest, _ completion: @escaping CompletionBlock<JSON>) -> Request {
        return self.call(request: request, parse: JSONResponse(), completion)
    }
    
    /**
     A convenient method to which outputs its response as String using Alamofire's `responseString`
     */
    @discardableResult
    public func callString(request: APIRequest, _ completion: @escaping CompletionBlock<String>) -> Request {
        return request.toAlamofire().validate().responseString(queue: Queue.network,
                                                            completionHandler: { [completion] (response) in
            DispatchQueue.main.async {
                completion(response.result.isSuccess, response.result, response.response)
            }
        })
    }
    
    /**
     Executes the call of the specified `APIRequest` with Data response
     
     - parameter completion: A completion block to handle the response.
     
     - returns: The Alamofire `Request` that can be used to cancel the request.
     */
    @discardableResult
    public func callData(request: APIRequest, _ completion: @escaping CompletionBlock<Data>) -> Request {
        Log.debug("Requesting: \(request.apiPath)")
        return request.toAlamofire().validate().responseData(completionHandler: { (response) in
            DispatchQueue.main.async {
                completion(response.result.isSuccess, response.result, response.response)
            }
        })
    }
    
}

