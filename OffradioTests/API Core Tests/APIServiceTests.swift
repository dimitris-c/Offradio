//
//  APIServiceTests.swift
//  Offradio
//
//  Created by Dimitris C. on 25/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa
import XCTest
@testable import Offradio

class APIServiceTests: XCTestCase {
    
    let timeout: TimeInterval = 30.0
    var jsonAPIService: APIService<JSON>?
    var dummyModelAPIService: APIService<DummyModel>?
    var dummyModelArrayAPIService: APIService<[DummyModel]>?
    
    var mockJSONData: JSON?
    
    override func setUp() {
        super.setUp()
        
        let bundle          = Bundle(for: type(of: self))
        let path            = bundle.path(forResource: "mock-person", ofType: "json")!
        let jsonData        = NSData(contentsOfFile: path)
        self.mockJSONData   = JSON(jsonData!)
        
    }

    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAPIServiceReturnsErrorWhenApiCallFails() {
        // Given
        let path        = "https://httpbin.org/wrong-api-path"
        let request     = APIRequest(apiPath: path)
        let response    = JSONResponse()
        
        var error: Error?
        let expectation = self.expectation(description: "APIService should return error for: \(path)")
        
        // When
        self.jsonAPIService  = APIService<JSON>(request: request, parse: response)
        self.jsonAPIService?.call { (success, model, headers) in
            if !success {
                error = model.error
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNotNil(error?.localizedDescription)
    }

    func testAPIServiceReturnsDummyModel() {
        // Given
        let path        = "http://clients.dimmdesign.com/api/dummymodel.json"
        let request     = APIRequest(apiPath: path)
        let response    = DummyAPIResponse()
        
        var dummyModel: DummyModel?
        let expectation = self.expectation(description: "APIService should return success along with DummyModel for: \(path)")
        
        // When
        self.dummyModelAPIService = APIService<DummyModel>(request: request, parse: response)
        self.dummyModelAPIService?.call({ (success, model, headers) in
            if success && model.isSuccess() {
                dummyModel = model.value
                expectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNotNil(dummyModel)
        XCTAssertEqual(dummyModel!.name, "Dimitris")
        XCTAssertEqual(dummyModel!.lastName, "Chatzieleftheriou")
        XCTAssertEqual(dummyModel!.fullName, "Dimitris Chatzieleftheriou")
    }
    
    func testAPIServiceReturnsDummyModelArray() {
        // Given
        let path        = "http://clients.dimmdesign.com/api/dummypersons.json"
        let request     = APIRequest(apiPath: path)
        let response    = ArrayDummyAPIResponse()
        
        var dummyModel: [DummyModel]?
        let expectation = self.expectation(description: "APIService should return success along with array of DummyModel for: \(path)")
        
        // When
        self.dummyModelArrayAPIService = APIService<[DummyModel]>(request: request, parse: response)
        self.dummyModelArrayAPIService?.call({ (success, model, headers) in
            if success && model.isSuccess() {
                dummyModel = model.value
                expectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNotNil(dummyModel)
        XCTAssert(dummyModel!.count > 0)
        XCTAssertNotNil(dummyModel!.first)
        XCTAssertEqual(dummyModel!.first!.name, "Dimitris")
        XCTAssertEqual(dummyModel!.first!.lastName, "Chatzieleftheriou")
        XCTAssertEqual(dummyModel!.first!.fullName, "Dimitris Chatzieleftheriou")
    }
    
    func testAPIServiceReactiveImplementationReturnsObservableAndFails() {
        // Given
        let path        = "https://httpbin.org/wrong-api-path"
        let request     = APIRequest(apiPath: path)
        let response    = JSONResponse()
        
        var expectedError: Error?
        let expectation = self.expectation(description: "APIService should return error for: \(path)")
        
        // When
        self.jsonAPIService  = APIService<JSON>(request: request, parse: response)
        let observable: Observable<JSON>? = self.jsonAPIService?.rxCall()
        let disposable = observable?.subscribe(onError: { (error) in
            expectedError = error
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        disposable?.dispose()
        
        // Then
        XCTAssertNotNil(observable)
        XCTAssertNotNil(expectedError?.localizedDescription)
        
    }
    
    func testAPIServiceReactiveImplementationReturnsDummyModelAndUpdatesVariableModel() {
        // Given
        let path        = "http://clients.dimmdesign.com/api/dummymodel.json"
        let request     = APIRequest(apiPath: path)
        let response    = DummyAPIResponse()
        
        let dummyModel  = Variable<DummyModel?>(nil)
        let expectation = self.expectation(description: "APIService should return success along with DummyModel for: \(path)")
        
        // When
        self.dummyModelAPIService = APIService<DummyModel>(request: request, parse: response)
        let disposable = self.dummyModelAPIService?.rxCall().do(onNext: { model in
            expectation.fulfill()
        }).bind(to: dummyModel)
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        disposable?.dispose()
        
        // Then
        XCTAssertNotNil(dummyModel.value)
        XCTAssertEqual(dummyModel.value!.name, "Dimitris")
        XCTAssertEqual(dummyModel.value!.lastName, "Chatzieleftheriou")
        XCTAssertEqual(dummyModel.value!.fullName, "Dimitris Chatzieleftheriou")
        
    }
    
    func testAPIMockDataReturnsPassedData() {
        
        let expectation = self.expectation(description: "MockJSONAPiService should return json")
        
        var result: JSON?
        let service = MockJSONAPIService(with: self.mockJSONData!)
        service.call { (success, data, headers) in
            if success {
                result = data.value
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssertNotNil(result)
        
    }
    
    func testAPIMockDataReturnsPassedDataAsReactive() {
        let expectation = self.expectation(description: "MockJSONAPiService should return json")
        
        let result: Variable<JSON?> = Variable<JSON?>(nil)
        let service = MockJSONAPIService(with: self.mockJSONData!)
        
        let observable = service.rxCall().asObservable().subscribe(onNext: { (json) in
            result.value = json
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        observable.dispose()
        
        XCTAssertNotNil(result)
    }
    
}
