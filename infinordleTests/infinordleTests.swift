//
//  infinordleTests.swift
//  infinordleTests
//
//  Created by James Williams on 30/08/2025.
//

import Testing
@testable import infinordle

struct infinordleTests {

    @Test func testWinningCondition() {
        let game = GameLogic()
        game.secretWord = "APPLE"
        game.guess = "APPLE"
        game.submitGuess()
        #expect(game.showWinAlert == true)
    }

    @Test func testLosingCondition() {
        let game = GameLogic()
        game.secretWord = "APPLE"
        game.submittedGuesses = ["BREAD", "CHAIR", "PLANT", "TIGER", "SMILE"]
        game.guess = "GHOST"
        game.submitGuess()
        #expect(game.showLossAlert == true)
    }

    @Test func testInvalidWord() {
        let game = GameLogic()
        game.secretWord = "APPLE"
        game.guess = "QWERT"
        game.submitGuess()
        #expect(game.showInvalidWordAlert == true)
    }

    @Test func testCorrectLetterCorrectPosition() {
        let game = GameLogic()
        game.secretWord = "APPLE"
        game.submittedGuesses = ["APRICOT"]
        let color = game.cellColor(for: "A", at: 0, rowIndex: 0)
        #expect(color == (0, 1, 0))
    }

    @Test func testCorrectLetterWrongPosition() {
        let game = GameLogic()
        game.secretWord = "APPLE"
        game.submittedGuesses = ["GRAPE"]
        let color = game.cellColor(for: "P", at: 2, rowIndex: 0)
        #expect(color == (1, 1, 0))
    }

    @Test func testIncorrectLetter() {
        let game = GameLogic()
        game.secretWord = "APPLE"
        game.submittedGuesses = ["BREAD"]
        let color = game.cellColor(for: "B", at: 0, rowIndex: 0)
        #expect(color == (0.5, 0.5, 0.5))
    }
    
    @Test func testResetGame() {
        let game = GameLogic()
        game.secretWord = "APPLE"
        game.guess = "BREAD"
        game.submittedGuesses = ["CHAIR"]
        game.showWinAlert = true
        
        game.resetGame()
        
        #expect(game.secretWord != "APPLE")
        #expect(game.guess == "")
        #expect(game.submittedGuesses.isEmpty == true)
        #expect(game.showWinAlert == false)
    }
}