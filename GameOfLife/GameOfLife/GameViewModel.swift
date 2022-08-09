//
//  GameViewModel.swift
//  GameOfLife
//
//  Created by Kevin Roebuck on 4/8/22.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published private var model: GameModel
    
    weak var timer: Timer?
    @Published var timerInterval = 0.2
    
    @Published var gridHeight: Int {
        didSet {
            if gridHeight < 1 {
                gridHeight = 1
            }
        }
    }
    
    @Published var gridWidth: Int {
        didSet {
            if gridWidth < 1 {
                gridWidth = 1
            }
        }
    }
    
    @Published var savedGrid: [[Cell]]? = nil
    
    init(height: Int = 12, width: Int = 16) {
        self.gridHeight = height
        self.gridWidth = width
        model = GameViewModel.createGame(height: height, width: width)
    }
    
    // The arrays in GridPresets are of this form
    init(grid: [[Bool]]) {
        self.gridHeight = grid.count
        self.gridWidth = grid[0].count
        model = GameModel(grid: grid)
    }
    
    private static func createGame(height: Int, width: Int) -> GameModel {
        GameModel(height: height, width: width)
    }
    
    private static func createGame(from grid: [[Cell]]) -> GameModel {
        GameModel(grid: grid)
    }
    
    var width: Int {
        model.width
    }
    
    var height: Int {
        model.height
    }
    
    var grid: [[Cell]] {
        model.grid
    }
    
    var isToroidal: Bool {
        get { model.isToroidal }
        set { model.toggleIsToroidal() }
    }

    var generation: Int {
        model.generation
    }
    
    var population: Int {
        model.population
    }
    
    // MARK: Intent(s)
    
    func advanceGameState() {
        timer?.invalidate()
        if !model.advanceGameState() {
            stopTimer()
        }
    }
    
    func evolveSystem() {
        if model.advanceGameState() {
            timer?.invalidate() // In case of existing timer already, invalidate before we lose the reference to it
            timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] _ in
                if let changeDidOccur = self?.model.advanceGameState() {
                    if !changeDidOccur {
                        self?.stopTimer()
                    }
                }
            }
        }
    }
    
    func newGame() {
        timer?.invalidate()
        model = GameViewModel.createGame(height: gridHeight, width: gridWidth)
    }
    
    func saveGridState() {
        savedGrid = grid
    }
    
    func loadGridState() {
        timer?.invalidate()
        if savedGrid != nil {
            model = GameViewModel.createGame(from: savedGrid!)
        }
    }
    
    func stopTimer() {
        objectWillChange.send() // refresh GameView (because we're not updating the model)
        timer?.invalidate()
        timer = nil
    }
    
    func toggleValue(of cell: Cell) {
        model.toggleIsAlive(of: cell)
    }
}
