//
//  WelcomeView.swift
//  GameOfLife
//
//  Created by Kevin Roebuck on 4/26/22.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject private var game = GameViewModel(grid: GridPresets.gliderGun)
    
    @State private var actionState: Int? = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Game of Life")
                        .font(.system(size: 48, weight: .bold))
                    GameBoard(game: game).padding(.horizontal).disabled(true)
                    banner("PLAY").onTapGesture {
                        self.asyncTask(1)
                    }
                    banner("RULES").onTapGesture {
                        self.asyncTask(2)
                    }
                    gameLink
                    rulesLink
                    Text("")
                }
            }.navigationBarTitleDisplayMode(.inline)
        }.onAppear {
            game.timerInterval = 0.1
            game.evolveSystem()
        }
    }
    
    // NavigationLink.onDisappear { game.stopTimer() } wasn't working correctly
    // GameView would load and the game board there would sometimes change pending on
    // the state of the scheduled timer.
    private func asyncTask(_ actionState: Int) {
        if actionState == 1 {
            game.stopTimer()
        }
        self.actionState = actionState
    }
    
    private var gameLink: some View {
        NavigationLink(
            destination: GameView(game: GameViewModel()),
            tag: 1,
            selection: $actionState,
            label: {
                EmptyView()
            }
        )
    }
    
    private var rulesLink: some View {
        NavigationLink(
            destination: RulesView(),
            tag: 2,
            selection: $actionState,
            label: {
                EmptyView()
            }
        )
    }
    
    private func banner(_ text: String) -> some View {
        HStack {
            Spacer()
            Text("\(text)").foregroundColor(.black)
                .font(.system(size:32, weight: .bold))
                .padding()
            Spacer()
        }
        .background(Color.blue.opacity(0.3))
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
