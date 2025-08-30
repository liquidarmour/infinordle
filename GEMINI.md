# Gemini Swift App Guide

This guide provides helpful information for working on the Infinordle Swift application.

## Project Overview

Infinordle is a Wordle-like game built with SwiftUI. The goal is to guess a secret 5-letter word within six attempts.

## Getting Started

To build and run the application:

1.  Open `infinordle.xcodeproj` in Xcode.
2.  Select a simulator or a connected device.
3.  Click the "Run" button (or press `Cmd+R`).

## Testing

To run the unit and UI tests:

1.  Open `infinordle.xcodeproj` in Xcode.
2.  Select a simulator or a connected device.
3.  Go to "Product" > "Test" (or press `Cmd+U`).

Alternatively, you can run the tests from the command line:

```bash
xcodebuild test -scheme infinordle \
               -destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=latest'
```

## Project Structure

-   `infinordle/`: Contains the main application source code.
    -   `infinordleApp.swift`: The main entry point of the application.
    -   `ContentView.swift`: The main view of the application.
    -   `GameLogic.swift`: Contains the game's logic and state.
    -   `WordList.swift`: A list of valid 5-letter words.
    -   `Assets.xcassets`: Image and color assets.
-   `infinordleTests/`: Contains the unit tests.
-   `infinordleUITests/`: Contains the UI tests.
-   `.github/workflows/ci.yml`: The GitHub Actions workflow for continuous integration.

## Workflow

If the current ticket number is not known, please ask for it.

```