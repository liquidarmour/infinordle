//
//  ContentView.swift
//  infinordle
//
//  Created by James Williams on 30/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var game = GameLogic()

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 10)
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

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(game.letters.map { String($0) }, id: \.self) { letter in
                        Button(action: {
                            game.handleKeyPress(letter)
                        }) {
                            Text(letter)
                                .font(.title)
                                .frame(width: 30, height: 50)
                                .background(game.keyboardKeyColor(for: Character(letter)))
                                .cornerRadius(5)
                        }
                    }
                }
                .padding()
                
                HStack {
                    Button(action: {
                        game.handleKeyPress(GameLogic.deleteKey)
                    }) {
                        Text("Delete")
                            .font(.title)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        game.handleKeyPress(GameLogic.enterKey)
                    }) {
                        Text("Enter")
                            .font(.title)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
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
