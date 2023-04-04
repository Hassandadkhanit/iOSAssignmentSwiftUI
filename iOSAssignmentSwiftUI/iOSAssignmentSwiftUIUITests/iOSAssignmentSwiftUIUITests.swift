
//
//  iOSAssignmentSwiftUIUITests.swift
//  iOSAssignmentSwiftUIUITests
//
//  Created by Hassan dad khan on 03/04/2023.
//

import XCTest

final class iOSAssignmentSwiftUIUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        XCUIApplication().collectionViews/*@START_MENU_TOKEN@*/.staticTexts["The Key To Success In iPhone Photography"]/*[[".cells.staticTexts[\"The Key To Success In iPhone Photography\"]",".staticTexts[\"The Key To Success In iPhone Photography\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
            XCUIApplication().collectionViews/*@START_MENU_TOKEN@*/.staticTexts["The Key To Success In iPhone Photography"]/*[[".cells.staticTexts[\"The Key To Success In iPhone Photography\"]",".staticTexts[\"The Key To Success In iPhone Photography\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        }
    }
}
