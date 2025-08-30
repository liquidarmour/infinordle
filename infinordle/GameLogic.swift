//
//  GameLogic.swift
//  infinordle
//
//  Created by James Williams on 30/08/2025.
//

import Foundation

class GameLogic: ObservableObject {
    @Published var guess = ""
    @Published var submittedGuesses: [String] = []
    @Published var secretWord = fiveLetterWords.randomElement() ?? "SWIFT"
    @Published var showWinAlert = false
    @Published var showLossAlert = false
    @Published var showInvalidWordAlert = false

    let keyboardRows: [[String]] = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["ENTER", "Z", "X", "C", "V", "B", "N", "M", "DELETE"]
    ]

    init() {
        if let secretWordEnv = ProcessInfo.processInfo.environment["SECRET_WORD"] {
            if fiveLetterWords.contains(secretWordEnv) {
                self.secretWord = secretWordEnv
            }
        }
    }

    func submitGuess() {
        guard guess.count == 5 else { return }
        guard fiveLetterWords.contains(guess) else {
            showInvalidWordAlert = true
            guess = ""
            return
        }
        submittedGuesses.append(guess)

        if guess == secretWord {
            showWinAlert = true
        } else if submittedGuesses.count >= 6 {
            showLossAlert = true
        }
        guess = ""
    }

    func resetGame() {
        secretWord = fiveLetterWords.randomElement() ?? "SWIFT"
        submittedGuesses = []
        guess = ""
        showWinAlert = false
        showLossAlert = false
        showInvalidWordAlert = false
    }

    func cellColor(for character: Character?, at colIndex: Int, rowIndex: Int) -> (red: Double, green: Double, blue: Double) {
        guard let character = character, submittedGuesses.count > rowIndex else { return (1, 1, 1) } // white
        
        let submittedWord = submittedGuesses[rowIndex]
        let secretWordArray = Array(secretWord)
        
        if submittedWord.count > colIndex {
            let letter = submittedWord[submittedWord.index(submittedWord.startIndex, offsetBy: colIndex)]
            if letter == secretWordArray[colIndex] {
                return (0, 1, 0) // green
            } else if secretWord.contains(letter) {
                return (1, 1, 0) // yellow
            } else {
                return (0.5, 0.5, 0.5) // gray
            }
        }
        
        return (1, 1, 1) // white
    }
}
