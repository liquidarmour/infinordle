//
//  ContentView.swift
//  infinordle
//
//  Created by James Williams on 30/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var game = GameLogic()

    let letterColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)


    var body: some View {
        ZStack {
            VStack {
                LazyVGrid(columns: letterColumns, spacing: 10) {
                    ForEach(0..<30) { index in
                        let rowIndex = index / 5
                        let colIndex = index % 5
                        let character: Character? = (game.submittedGuesses.count > rowIndex && game.submittedGuesses[rowIndex].count > colIndex) ? game.submittedGuesses[rowIndex][game.submittedGuesses[rowIndex].index(game.submittedGuesses[rowIndex].startIndex, offsetBy: colIndex)] : nil
                        let currentGuessCharacter: Character? = (rowIndex == game.submittedGuesses.count && game.guess.count > colIndex) ? game.guess[game.guess.index(game.guess.startIndex, offsetBy: colIndex)] : nil
                        
                        let colorTuple = game.cellColor(for: character, at: colIndex, rowIndex: rowIndex)
                        
                        Text(String(currentGuessCharacter ?? character ?? " "))
                            .font(.largeTitle)
                            .frame(width: 60, height: 60)
                            .border(Color.black)
                            .background(Color(red: colorTuple.red, green: colorTuple.green, blue: colorTuple.blue))
                    }
                }
                .padding()

                Spacer()

                VStack {
                    ForEach(game.keyboardRows, id: \.self) { row in
                        HStack(spacing: 5) {
                            ForEach(row, id: \.self) { key in
                                Button(action: {
                                    if key == "DELETE" {
                                        if !game.guess.isEmpty {
                                            game.guess.removeLast()
                                        }
                                    } else if key == "ENTER" {
                                        game.submitGuess()
                                    } else if game.guess.count < 5 {
                                        game.guess += key
                                    }
                                }) {
                                    Text(key)
                                        .font(.system(size: key.count > 1 ? 14 : 18))
                                        .frame(minWidth: 20)
                                        .padding(10)
                                        .background(Color.gray.opacity(0.5))
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .padding()
            .alert("You Win!", isPresented: $game.showWinAlert) {
                Button("Play Again", action: game.resetGame)
            }
            .alert("You Lose!", isPresented: $game.showLossAlert) {
                Button("Play Again", action: game.resetGame)
            } message: {
                Text("The word was \(game.secretWord)")
            }

            if game.showInvalidWordAlert {
                Text("Invalid Word")
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            game.showInvalidWordAlert = false
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
