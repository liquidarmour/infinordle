//
//  infinordleUITests.swift
//  infinordleUITests
//
//  Created by James Williams on 30/08/2025.
//

import XCTest

final class infinordleUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testGameFlow() throws {
        let app = XCUIApplication()
        app.launchEnvironment = ["SECRET_WORD": "APPLE"]
        app.launch()

        // This is a simple test that simulates a winning game.
        // Note: This test assumes the secret word is known for testing purposes.
        // In a real-world scenario, you might inject a specific word for testing.
        
        let secretWord = "APPLE" // Assuming we know the word for the test

        for letter in secretWord {
            app.buttons[String(letter)].tap()
        }
        
        app.buttons["ENTER"].tap()
        
        // Check for the "You Win!" alert
        let winAlert = app.alerts["You Win!"]
        XCTAssertTrue(winAlert.waitForExistence(timeout: 5))
        
        winAlert.buttons["Play Again"].tap()
        
        // After winning and tapping "Play Again", the game should reset.
        // We can verify this by checking if the grid is empty again.
        let firstCell = app.staticTexts.element(boundBy: 0)
        XCTAssertEqual(firstCell.label, " ")
    }

    @MainActor
    func testInvalidWordPopup() throws {
        let app = XCUIApplication()
        app.launch()

        let invalidWord = "QWERT"
        for letter in invalidWord {
            app.buttons[String(letter)].tap()
        }
        
        app.buttons["ENTER"].tap()
        
        let invalidWordPopup = app.staticTexts["Invalid Word"]
        XCTAssertTrue(invalidWordPopup.waitForExistence(timeout: 1))
        
        // The popup should disappear after 3 seconds, so we'll wait for it to disappear.
        // We'll use a longer timeout here to account for the 3-second delay.
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"), object: invalidWordPopup)
        wait(for: [expectation], timeout: 5)
    }
}