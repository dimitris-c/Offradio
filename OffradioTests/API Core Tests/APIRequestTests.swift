//
//  APIServiceTests.swift
//  Offradio
//
//  Created by Dimitris C. on 24/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import XCTest
import Alamofire
@testable import Offradio

class APIRequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: RequestParameters Tests
    func testRequestParametersHasNilParam() {
        // Given
        let encoding = URLEncoding.default
        
        // When
        let requestParameters: RequestParameters = RequestParameters(encoding: encoding)
        
        // Then
        XCTAssertNil(requestParameters.values)
    }
    
    func testRequestParametersHasParameters() {
        // Given
        let params: Parameters? = ["": ""]
        
        // When
        let requestParameters: RequestParameters = RequestParameters(parameters: params)
        
        // Then
        XCTAssertNotNil(requestParameters.values)
    }
    
    // MARK: APIRequest Tests
    func testAPIRequestHasPath() {
        // Given
        let path = "https://domain.com/some-api/"
        
        // When
        let request = APIRequest(apiPath: path)
        
        // Then
        XCTAssertNotNil(request.url)
    }
    
    func testAPIRequestHasPathAndMethod() {
        // Given
        let path = "https://domain.com/some-api/"
        let method = HTTPMethod.get
        
        // When
        let request = APIRequest(apiPath: path, method: method)
        
        // Then
        XCTAssertNotNil(request.url)
        XCTAssert(request.method == .get)
    }
    
    func testAPIRequestHasPathMethodAndParameters() {
        // Given
        let parameters  = RequestParameters(parameters: ["":""],
                                           encoding: JSONEncoding.default)
        // When
        let request     = APIRequest(apiPath: "https://domain.com/some-api/",
                                 method: .post,
                                 parameters: parameters)
        
        // Then
        XCTAssertNotNil(request.url)
        XCTAssert(request.method == .post)
        XCTAssertNotNil(request.parameters)
    }
    
    func testAPIRequestHasAllValuesAssigned() {
        // Given
        let parameters  = RequestParameters(parameters: ["":""],
                                           encoding: JSONEncoding.default)
        let headers     = ["": ""]
        
        // When
        let request     = APIRequest(apiPath: "https://domain.com/some-api/",
                                     method: .post,
                                     parameters: parameters,
                                     headers: headers)
        
        // Then
        XCTAssertNotNil(request.url)
        XCTAssert(request.method == .post)
        XCTAssertNotNil(request.parameters)
        XCTAssertNotNil(request.headers)
    }
    
    func testAPIRequestConvertsToAlamofireRequest() {
        // Given
        let request = APIRequest(apiPath: "https://domain.com/some-api/",
                                 method: .get)
        
        // When 
        let alamofireRequest = request.toAlamofire()
        
        // Then
        XCTAssertNotNil(alamofireRequest)
    }
    
}
