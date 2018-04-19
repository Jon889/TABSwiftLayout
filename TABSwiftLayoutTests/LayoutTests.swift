//
//  LayoutTests.swift
//  TABSwiftLayoutTests
//
//  Created by Jonathan on 29/12/2017.
//  Copyright © 2017 TheAppBusiness. All rights reserved.
//

import XCTest
import TABSwiftLayout

class LayoutTests: XCTestCase {
    
    private func simpleViewHierarchy() -> (UIView, UIView) {
        let superview = UIView()
        let subview = UIView()
        superview.addSubview(subview)
        return (superview, subview)
    }
    
    func testPinEdges() {
        let (sv, v) = simpleViewHierarchy()
        let constraints = v.pin(edges: .all, toView: sv, relation: .equal, margins: EdgeMargins(top: 1, left: 2, bottom: 3, right: 4), priority: 1000)
        XCTAssertEqual(constraints.count, 4)
        XCTAssertTrue(constraints.contains { $0.firstAttribute == .top && $0.constant == 1 })
        XCTAssertTrue(constraints.contains { $0.firstAttribute == .left && $0.constant == 2 })
        XCTAssertTrue(constraints.contains { $0.firstAttribute == .bottom && $0.constant == -3 })
        XCTAssertTrue(constraints.contains { $0.firstAttribute == .right && $0.constant == -4 })
        constraints.forEach {
            XCTAssertTrue($0.isActive)
            XCTAssertEqual($0.secondItem as? UIView, sv)
            XCTAssertEqual($0.relation, .equal)
            XCTAssertEqual($0.priority, 1000)
        }
        XCTAssertEqual(sv.constraints, constraints)
        XCTAssertEqual(v.constraints.count, 0)
    }
    
    func testPinEdge() {
        let (sv, v) = simpleViewHierarchy()
        let constraint = v.pin(edge: .top, toEdge: .bottom, ofView: sv, relation: .greaterThanOrEqual, margin: 20, priority: 1000)
        XCTAssertEqual(constraint.firstAttribute, .top)
        XCTAssertEqual(constraint.secondAttribute, .bottom)
        XCTAssertEqual(constraint.secondItem as? UIView, sv)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        //it is minus 20 because +20 would be 20 beyond (below) the sv bottom
        XCTAssertEqual(constraint.constant, -20)
        XCTAssertEqual(constraint.priority, 1000)
        XCTAssertTrue(constraint.isActive)
        
        XCTAssertEqual(sv.constraints, [constraint])
        XCTAssertEqual(v.constraints.count, 0)
    }
    
    func testAlignAxis() {
        let (sv, v) = simpleViewHierarchy()
        let constraint = v.align(axis: .horizontal, relativeTo: sv, offset: 20, priority: 750)
        XCTAssertEqual(constraint.firstAttribute, .centerX)
        XCTAssertEqual(constraint.secondAttribute, .centerX)
        XCTAssertEqual(constraint.secondItem as? UIView, sv)
        XCTAssertEqual(constraint.constant, 20)
        XCTAssertEqual(constraint.priority, 750)
        XCTAssertTrue(constraint.isActive)
        
        XCTAssertEqual(sv.constraints, [constraint])
        XCTAssertEqual(v.constraints.count, 0)
    }
    
}
