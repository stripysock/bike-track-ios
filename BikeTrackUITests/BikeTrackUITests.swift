//
//  BikeTrackUITests.swift
//  BikeTrackUITests
//
//  Created by Adam Cooper on 25/8/2023.
//

import XCTest

final class BikeTrackUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSignUpAppearance() throws {
        app.buttons["Create Account"].tap()
        
        let signInMessage = app.staticTexts["Sign up for an account."]
        XCTAssert(signInMessage.waitForExistence(timeout: 0.5))
    }
    
    func testSignUpFormValidation() throws {
        try testSignUpAppearance()
        
        let emailField = app.textFields["Email"]
        let passwordField = app.secureTextFields["Password"]
        let submitField = app.buttons["Sign Up"]
        
        XCTAssert(emailField.waitForExistence(timeout: 0.5))
        XCTAssert(passwordField.waitForExistence(timeout: 0.5))
        XCTAssert(submitField.waitForExistence(timeout: 0.5))
        
        emailField.tap()
        emailField.typeText("adam@stripysock.com.au")
        XCTAssert(!submitField.isEnabled)
        
        passwordField.tap()
        passwordField.typeText("password")
        XCTAssert(submitField.isEnabled)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
