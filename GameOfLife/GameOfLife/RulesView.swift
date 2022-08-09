//
//  RulesView.swift
//  GameOfLife
//
//  Created by Kevin Roebuck on 4/26/22.
//

import SwiftUI

struct RulesView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Section {
                            Text("Each cell with one or no neighbors dies, as if by solitude.").padding(.horizontal)
                            toofewNeighborsView.frame(width: geometry.size.width, height: 100)
                            
                            Text("Each cell with four or more neighbors dies, as if by overpopulation.").padding(.horizontal)
                            tooManyNeighborsView.frame(width: geometry.size.width, height: 100)
                            
                            Text("Each cell with two or three neighbors survives.").padding(.horizontal)
                            twoNeighborsView.frame(width: geometry.size.width, height: 100)
                        } header: {
                            Text("Populated")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.bottom)
                        }
                        Section {
                            Text("Each cell with three neighbors becomes populated.").padding(.horizontal)
                            emptyThreeNeighborsView.frame(width: geometry.size.width, height: 100)
                        } header: {
                            Text("Unpopulated")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.vertical)
                        }
                        .padding(.bottom)
                    }
                    .disabled(true)
                }
                .navigationTitle("How to play")
            }
        }
    }
    
    private var toofewNeighborsView: some View {
        HStack {
            GameBoard(game: GameViewModel(grid: GridPresets.tooFewNeighbors))
            Image(systemName: "arrow.right").font(.title)
            GameBoard(game: GameViewModel(grid: GridPresets.tooFewNeighborsNext))
        }
    }
    
    private var tooManyNeighborsView: some View {
        HStack {
            GameBoard(game: GameViewModel(grid: GridPresets.tooManyNeighbors))
            Image(systemName: "arrow.right").font(.title)
            GameBoard(game: GameViewModel(grid: GridPresets.tooManyNeighborsNext))
        }
    }
    
    private var twoNeighborsView: some View {
        HStack {
            GameBoard(game: GameViewModel(grid: GridPresets.twoNeighbors))
            Image(systemName: "arrow.right").font(.title)
            GameBoard(game: GameViewModel(grid: GridPresets.twoNeighborsNext))
        }
    }
    
    private var emptyThreeNeighborsView: some View {
        HStack {
            GameBoard(game: GameViewModel(grid: GridPresets.emptyThreeNeighbors))
            Image(systemName: "arrow.right").font(.title)
            GameBoard(game: GameViewModel(grid: GridPresets.emptyThreeNeighborsNext))
        }
    }
}








struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
    }
}
