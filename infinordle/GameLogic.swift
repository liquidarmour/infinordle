//
//  GameLogic.swift
//  infinordle
//
//  Created by James Williams on 30/08/2025.
//

import Foundation
import SwiftUI

enum LetterStatus {
    case correct, misplaced, wrong, unknown
}

class GameLogic: ObservableObject {
    @Published var guess = ""
    @Published var submittedGuesses: [String] = []
    @Published var secretWord = fiveLetterWords.randomElement() ?? "SWIFT"
    @Published var showWinAlert = false
    @Published var showLossAlert = false
    @Published var showInvalidWordAlert = false
    @Published var letterStatuses: [Character: LetterStatus] = [:]

    let letters = "QWERTYUIOPASDFGHJKLZXCVBNM"
    
    static let enterKey = "ENTER"
    static let deleteKey = "DELETE"

    init() {
        if let secretWordEnv = ProcessInfo.processInfo.environment["SECRET_WORD"] {
            if fiveLetterWords.contains(secretWordEnv) {
                self.secretWord = secretWordEnv
            }
        }
        resetLetterStatuses()
    }

    func submitGuess() {
        guard guess.count == 5 else { return }
        guard fiveLetterWords.contains(guess) else {
            showInvalidWordAlert = true
            guess = ""
            return
        }
        submittedGuesses.append(guess)
        updateLetterStatuses()

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
        resetLetterStatuses()
    }
    
    func resetLetterStatuses() {
        for char in letters {
            letterStatuses[char] = .unknown
        }
    }

    func updateLetterStatuses() {
        guard let lastGuess = submittedGuesses.last else { return }
        let secretWordArray = Array(secretWord)

        for (index, char) in lastGuess.enumerated() {
            if secretWordArray[index] == char {
                letterStatuses[char] = .correct
            } else if secretWord.contains(char) {
                if letterStatuses[char] != .correct {
                    letterStatuses[char] = .misplaced
                }
            } else {
                letterStatuses[char] = .wrong
            }
        }
    }

    func keyboardKeyColor(for letter: Character) -> Color {
        if let status = letterStatuses[letter] {
            switch status {
            case .correct:
                return .green
            case .misplaced:
                return .yellow
            case .wrong:
                return .gray
            case .unknown:
                return Color.gray.opacity(0.5)
            }
        }
        return Color.gray.opacity(0.5)
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
    
    func handleKeyPress(_ key: String) {
        if key == Self.deleteKey {
            if !guess.isEmpty {
                guess.removeLast()
            }
        } else if key == Self.enterKey {
            submitGuess()
        } else if guess.count < 5 {
            guess += key
        }
    }
}
