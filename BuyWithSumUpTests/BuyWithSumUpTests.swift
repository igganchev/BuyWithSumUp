//
//  BuyWithSumUpTests.swift
//  BuyWithSumUpTests
//
//  Created by Ivan Ganchev on 7.03.19.
//

import UIKit
import XCTest
@testable import BuyWithSumUp
import SumUpSDK

class BuyWithSumUpTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSumUpSDKIntegration() {
        XCTAssertTrue(SumUpSDK.testIntegration())
    }
}
