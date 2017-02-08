
//
//  Service.swift
//  Carlito
//
//  Created by Dimitris C. on 16/09/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias DataHandler = (_ response: JSON, _ headers: [AnyHashable: Any]?) -> Void
typealias CompletionBlock = (_ success: Bool, _ response: Any?, _ headers: [AnyHashable: Any]?) -> Void
typealias BoolBlock = (Bool) -> Void

public class APIService {
    
    static let queue: DispatchQueue = DispatchQueue(label: "gr.decimal.offradio.api-response-queue",
                                                    attributes: DispatchQueue.Attributes.concurrent)
    
    final let request: APIRequest
    final let parse: ResponseParse
    
    init(request: APIRequest, parse: ResponseParse) {
        self.request = request
        self.parse = parse
    }
    
    @discardableResult
    func call(_ completion: @escaping CompletionBlock) -> Request {
        let handler: (DataResponse<Any>) -> Void = { [weak self, completion] (response) in
            let status = response.response?.statusCode ?? 0
            print("Status: \(status)")
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = self?.parse.toData(rawData: json)
                dispatchMain {
                    completion(true, data, response.response?.allHeaderFields)
                }
                break
            case .failure(let error):
                if let data = response.data {
                    let json = JSON(data: data)
                    print("Error: \(error.localizedDescription)")
                    print("Response Error: \(json)")
                }
                dispatchMain {
                    completion(false, error.localizedDescription, response.response?.allHeaderFields)
                }
                break
            }
        }
        Log.debug("Requesting: \(self.request.url) \n with parameters: \(self.request.parameters.values)")
        return self.request.toAlamofire().validate().responseJSON(queue: APIService.queue, completionHandler: handler)
    }
    
    @discardableResult
    func callData(_ completion: @escaping CompletionBlock) -> Request {
        let handler: (DataResponse<Data>) -> Void = { (response) in
            let status = response.response?.statusCode ?? 0
            print("Status: \(status)")
            switch response.result {
            case .success(let value):
                dispatchMain {
                    completion(true, value, response.response?.allHeaderFields)
                }
                break
            case .failure(let error):
                print("\(error.localizedDescription)")
                dispatchMain {
                    completion(false, error.localizedDescription, response.response?.allHeaderFields)
                }
                break
            }
        }
        Log.debug("Requesting: \(self.request.url)")
        return self.request.toAlamofire().validate().responseData(queue: APIService.queue, completionHandler: handler)
    }
    
}

extension APIService {
    
    func responseHandler(showError:Bool = false, completion:CompletionBlock?, handler:@escaping DataHandler) -> (DataResponse<Any>) -> Void {
        return { response in
            let status = response.response?.statusCode ?? 0
            print("Status: \(status)")
            
            switch response.result {
            case .success (let data):
                let json = JSON(data)
                if status >= 200 && status < 300 {
                    print("Success")
                    handler(json, response.response?.allHeaderFields)
                } else {
                    print("Response failure \(json)")
                    completion?(false, json, ["status":status])
                }
                
            case .failure (let error):
                print("\(error.localizedDescription)")
                completion?(false, nil, ["status": status])
            }
        }
    }
}
