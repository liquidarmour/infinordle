# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Build and Run
- Open `infinordle.xcodeproj` in Xcode and use Cmd+R, or run:
  ```bash
  # Build only
  /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild build -scheme infinordle -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.6'
  
  # Run (requires simulator to be launched)
  xcodebuild -scheme infinordle -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=latest'
  ```

### Testing
- In Xcode: Product > Test (Cmd+U)
- Command line (use full Xcode path if xcode-select not set to Xcode):
  ```bash
  /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild test -scheme infinordle -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.6' -enableCodeCoverage YES
  ```

### Development Workflow
- Always run build first to verify code compiles before running tests
- If xcode-select points to CommandLineTools, use full Xcode path: `/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild`
- Build succeeding confirms syntax and basic compilation issues are resolved

## Architecture

This is a SwiftUI-based iOS Wordle clone with MVVM architecture:

- **GameLogic.swift**: ObservableObject containing all game state and logic
  - Manages current guess, submitted guesses, secret word
  - Handles word validation against `fiveLetterWords` array
  - Tracks letter statuses (correct/misplaced/wrong/unknown)
  - Supports SECRET_WORD environment variable for testing

- **ContentView.swift**: Main SwiftUI view displaying the game grid and keyboard
  - 6x5 letter grid with color coding (green/yellow/gray)
  - Virtual keyboard with letter status colors
  - Delete/Enter buttons and alert modals

- **WordList.swift**: Contains `fiveLetterWords` array for validation and secret word selection

### Key Game Logic
- Invalid words show a 3-second popup and clear the current guess
- Letter statuses update after each guess submission
- Game ends on correct guess or after 6 attempts
- Color coding: green (correct position), yellow (wrong position), gray (not in word)

### Testing Environment
- Unit tests: `infinordleTests/`
- UI tests: `infinordleUITests/` 
- CI runs on iPhone 16 Pro simulator with iOS 18.6