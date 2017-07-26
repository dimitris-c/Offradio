//
//  RxAPIService.swift
//  Omicron
//
//  Created by Dimitris C. on 24/06/2017.
//  Copyright © 2017 Decimal. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON
#if !COCOAPODS
import Omicron
#endif

// Subclass of APIService that returns Observable instances to use in RxSwift methods.
public extension RxAPIService {
    
    func call<Model>(request: APIRequest, parse: APIResponse<Model>) -> Observable<Model> {
        return Observable.create({ [request, parse] (observer) -> Disposable in
            let apiRequest = self.call(request: request, parse: parse, { (success, result, response) in
                if let value = result.value, success {
                    observer.on(.next(value))
                    observer.on(.completed)
                } else if let error = result.error {
                    observer.on(.error(error))
                }
            })
            return Disposables.create {
                apiRequest.cancel()
            }
        })
    }
    
    func callJSON(request: APIRequest) -> Observable<JSON> {
        return Observable.create({ (observer) -> Disposable in
            let apiRequest = self.callJSON(request: request, { (success, result, response) in
                if let value = result.value, success {
                    observer.on(.next(value))
                    observer.on(.completed)
                } else if let error = result.error {
                    observer.on(.error(error))
                }
            })
            return Disposables.create {
                apiRequest.cancel()
            }
        })
    }
    
    func callString(request: APIRequest) -> Observable<String> {
        return Observable.create({ (observer) -> Disposable in
            let apiRequest = self.callString(request: request, { (success, result, response) in
                if success {
                    if let value = result.value {
                        observer.on(.next(value))
                        observer.on(.completed)
                    } else {
                        observer.on(.error(APIError.parseError()))
                    }
                } else if let error = result.error {
                    observer.on(.error(error))
                }
            })
            return Disposables.create {
                apiRequest.cancel()
            }
        })
    }
    
    func callData(request: APIRequest) -> Observable<Data> {
        return Observable.create({ (observer) -> Disposable in
            let apiRequest = self.callData(request: request, { (success, result, response) in
                if success {
                    if let value = result.value {
                        observer.on(.next(value))
                        observer.on(.completed)
                    } else {
                        observer.on(.error(APIError.parseError()))
                    }
                } else if let error = result.error {
                    observer.on(.error(error))
                }
            })
            return Disposables.create {
                apiRequest.cancel()
            }
        })
    }
    
}
