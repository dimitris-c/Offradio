//
//  APIResponseTests.swift
//  Offradio
//
//  Created by Dimitris C. on 25/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import XCTest
import Alamofire
import SwiftyJSON
@testable import Offradio

class APIResponseTests: XCTestCase {
    
    var dummyModelJSON: JSON!
    var dummyArrayModelJSON: JSON!
    
    override func setUp() {
        super.setUp()
        
        dummyModelJSON      = JSON(["name": "Dimitris", "lastname": "Chatzieleftheriou"])
        dummyArrayModelJSON = JSON(["persons": [["name": "Dimitris",
                                                "lastname": "Chatzieleftheriou"]]])
        
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testAPIResponseDefaultImplementationReturnsNil() {
        // Given
        let dummyJSON   = JSON(["aField": "aValue"])
        let apiResponse = APIResponse<String>()
        
        // When
        let data = apiResponse.toData(rawData: dummyJSON)
        
        // Then
        XCTAssertNil(data)
    }
    
    func testAPIResponseReturnsDummyModel() {
        // Given
        let apiResponse = DummyAPIResponse()
        
        // When
        let data = apiResponse.toData(rawData: dummyModelJSON)
        
        // Then
        XCTAssertNotNil(data)
        XCTAssertEqual(data!.name, "Dimitris")
        XCTAssertEqual(data!.lastName, "Chatzieleftheriou")
        XCTAssertEqual(data!.fullName, "Dimitris Chatzieleftheriou")
    }
    
    func testAPIResponseReturnsArrayOfDummyModel() {
        // Given
        let apiResponse = ArrayDummyAPIResponse()
        
        // When
        let data = apiResponse.toData(rawData: dummyArrayModelJSON)
        
        
        // Then
        XCTAssertNotNil(data)
        XCTAssert(data!.count > 0)
    }
    
}
