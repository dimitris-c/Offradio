
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
import RxSwift

typealias CompletionBlock<Model> = (_ success: Bool, _ response: ModelResult<Model>, _ headers: [AnyHashable: Any]?) -> Void

enum APIError: Error {
    case error(String?)
}

internal struct Queue {
    fileprivate static let queueLabel: String = "gr.decimal.offradio.api-response-queue"
    static let network: DispatchQueue = DispatchQueue(label: queueLabel,
                                                      attributes: DispatchQueue.Attributes.concurrent)
}

public class APIService<Model> {
    
    final let request: APIRequest
    final let parse: APIResponse<Model>
    
    init(request: APIRequest, parse: APIResponse<Model>) {
        self.request = request
        self.parse = parse
    }
    
    @discardableResult
    func call(_ completion: @escaping CompletionBlock<Model>) -> Request {
        let handler: (DataResponse<Any>) -> Void = { [weak self, completion] (response) in
            let status = response.response?.statusCode ?? 0
            print("Status: \(status)")
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = self?.parse.toData(rawData: json)
                let modelResult = ModelResult(value: data, error: nil)
                dispatchMain {
                    completion(true, modelResult, response.response?.allHeaderFields)
                }
                break
            case .failure(let error):
                if let data = response.data {
                    let json = JSON(data: data)
                    print("Error: \(error.localizedDescription)")
                    print("Response Error: \(json)")
                }
                let modelResult = ModelResult<Model>(value: nil, error: error)
                dispatchMain {
                    completion(false, modelResult, response.response?.allHeaderFields)
                }
                break
            }
        }
        print("Requesting: \(self.request.url)")
        return self.request.toAlamofire().validate().responseJSON(queue: Queue.network, completionHandler: handler)
    }
    
    @discardableResult
    func callData(_ completion: @escaping CompletionBlock<Data>) -> Request {
        let handler: (DataResponse<Data>) -> Void = { (response) in
            let status = response.response?.statusCode ?? 0
            print("Status: \(status)")
            switch response.result {
            case .success(let value):
                let modelResult = ModelResult(value: value, error: nil)
                dispatchMain {
                    completion(true, modelResult, response.response?.allHeaderFields)
                }
                break
            case .failure(let error):
                print("\(error.localizedDescription)")
                let modelResult = ModelResult<Data>(value: nil, error: error)
                dispatchMain {
                    completion(false, modelResult, response.response?.allHeaderFields)
                }
                break
            }
        }
        print("Requesting: \(self.request.url)")
        return self.request.toAlamofire().validate().responseData(queue: Queue.network, completionHandler: handler)
    }
    
}

extension APIService {
    // Reactive call for the service.
    // NB. We don't use the ModelResult, as Observable's value is already generic.
    func rxCall() -> Observable<Model> {
        return Observable.create({ (observer) -> Disposable in
            let request = self.call({ (success, data, headers) in
                if success {
                    if let items = data.value {
                        observer.onNext(items)
                        observer.onCompleted()
                    } else {
                        observer.onError(APIError.error("Error while decoding data"))
                    }
                } else  {
                    observer.onError(APIError.error(data.error?.localizedDescription))
                }
            })
            return Disposables.create(with: { request.cancel() } )
        })
    }
    
    func rxCallData() -> Observable<Data> {
        return Observable.create({ (observer) -> Disposable in
            let request = self.callData({ (success, data, headers) in
                if success {
                    if let item = data.value {
                        observer.onNext(item)
                        observer.onCompleted()
                    } else {
                        observer.onError(APIError.error("Error while decoding data"))
                    }
                } else  {
                    observer.onError(APIError.error(data.error?.localizedDescription))
                }
            })
            return Disposables.create(with: { request.cancel() } )
        })
    }
    
}
