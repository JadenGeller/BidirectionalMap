//
//  BidirectionalMapTests.swift
//  BidirectionalMapTests
//
//  Created by Jaden Geller on 12/27/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import XCTest
@testable import BidirectionalMap

class BidirectionalMapTests: XCTestCase {
    let browsers: BidirectionalMap<String, String> = ["Apple" : "Safari", "Google" : "Chrome", "Microsoft" : "Edge", "Mozilla" : "Firefox"]

    func testMapping() {
        XCTAssertEqual(browsers.getAssociatedValue(left: "Apple"), "Safari")
        XCTAssertEqual(browsers.getAssociatedValue(right: "Safari"), "Apple")
        XCTAssertEqual(browsers.getAssociatedValue(left: "Microsoft"), "Edge")
        XCTAssertEqual(browsers.getAssociatedValue(right: "Edge"), "Microsoft")
    }
    
    func testValues() {
        XCTAssertEqual(Set(browsers.leftValues), ["Apple", "Google", "Microsoft", "Mozilla"])
        XCTAssertEqual(Set(browsers.rightValues), ["Safari", "Chrome", "Edge", "Firefox"])
    }
    
    func testRemove() {
        var copy = browsers
        XCTAssertEqual(copy.disassociateValues(left: "Apple"), "Safari")
        XCTAssertEqual(copy.getAssociatedValue(left: "Apple"), nil)
        XCTAssertEqual(copy.getAssociatedValue(right: "Safari"), nil)
        copy.disassociateAll()
        XCTAssertTrue(copy.isEmpty)
    }
}
