//
//  OffradioScreenshots.swift
//  Offradio
//
//  Created by Dimitris C. on 04/05/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import XCTest

class OffradioScreenshots: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        snapshot("0Launch")
        let tabBar = XCUIApplication().tabBars
        let secondButton = tabBar.buttons.element(boundBy: 1)
    }
    
}
