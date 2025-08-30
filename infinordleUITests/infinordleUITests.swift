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
        app.launch()

        // This is a simple test that simulates a winning game.
        // Note: This test assumes the secret word is known for testing purposes.
        // In a real-world scenario, you might inject a specific word for testing.
        
        let secretWord = "APPLE" // Assuming we know the word for the test

        for letter in secretWord {
            app.buttons[String(letter)].tap()
        }
        
        app.buttons["Enter"].tap()
        
        // Check for the "You Win!" alert
        let winAlert = app.alerts["You Win!"]
        XCTAssertTrue(winAlert.waitForExistence(timeout: 5))
        
        winAlert.buttons["Play Again"].tap()
        
        // After winning and tapping "Play Again", the game should reset.
        // We can verify this by checking if the grid is empty again.
        let firstCell = app.staticTexts.element(boundBy: 0)
        XCTAssertEqual(firstCell.label, " ")
    }
}