//
//  GameView.swift
//  GameOfLife
//
//  Created by Kevin Roebuck on 4/8/22.
//

import SwiftUI
//import Combine

struct GameView: View {
    @ObservedObject var game: GameViewModel
    
    var body: some View {
        VStack {
            Text("Cool Kevin's Game of Life").font(.title).fontWeight(.bold)
            ZStack {
                HStack {
                    Button("Save") {
                        game.saveGridState()
                    }
                    Spacer()
                    Button("Load") {
                        game.loadGridState()
                    }.disabled(game.savedGrid == nil)
                }.padding(.horizontal)
                VStack {
                    Text("Generation: \(game.generation)")
                    Text("Population: \(game.population)")
                }
            }
            gameBoard
            gameControls
            gridSettings
        }.navigationBarHidden(true)
    }
    
    var gameBoard: some View {
        GameBoard(game: game).padding(.horizontal)
    }
    
    var gameControls: some View {
        ZStack {
            HStack {
                Spacer()
                Button(action: { game.newGame() },
                       label: { Label("", systemImage: "arrow.clockwise") }
                )
                Spacer()
                Spacer()
                Spacer()
                Button(action: { game.advanceGameState() },
                       label: { Label("", systemImage: "chevron.forward") }
                )
                Spacer()
            }
            // Separate the play/pause button because the symbol change
            // affects width/spacing of the other buttons
            if game.timer == nil {
                Button(action: { game.evolveSystem() },
                       label: { Label("", systemImage: "arrowtriangle.forward.fill") }
                )
            } else {
                Button(action: { game.stopTimer() },
                       label: { Label("", systemImage: "pause.fill") }
                )
            }
        }.font(.title)
    }
    
    var gridSettings: some View {
        SettingsView(game: game)
    }
    
    struct CellView: View {
        var cell: Cell
        
        var body: some View {
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 4)
                    .opacity(cell.isAlive ? 1 : 0.2)
            }
        }
    }
}































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = GameViewModel()
        GameView(game: game)
    }
}
