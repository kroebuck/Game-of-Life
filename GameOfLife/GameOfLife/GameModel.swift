//
//  GameModel.swift
//  GameOfLife
//
//  Created by Kevin Roebuck on 4/8/22.
//

import Foundation

struct GameModel {
    private(set) var height: Int
    private(set) var width: Int
    private(set) var grid: [[Cell]]
    private(set) var isToroidal = true
    
    private(set) var generation = 0
    private(set) var population = 0
    
    // Generate random grid of specified dimensions
    init(height: Int, width: Int) {
        self.height = height
        self.width = width
        
        // randomly populate grid
        self.grid = [[Cell]]()
        
        for row in 0..<height {
            grid.append([Cell]())
            for col in 0..<width {
                let cell = Cell(x: col, y: row, isAlive: Bool.random())
                grid[row].append(cell)
                population += cell.isAlive ? 1 : 0
            }
        }
    }
    
    // Create a grid based on the one passed in
    init(grid: [[Bool]]) {
        self.height = grid.count
        self.width = grid[0].count
        
        // populate grid
        self.grid = [[Cell]]()
        
        for (rowIndex, row) in grid.enumerated() {
            self.grid.append([Cell]())
            for (colIndex, isAlive) in row.enumerated() {
                let cell = Cell(x: colIndex, y: rowIndex, isAlive: isAlive)
                self.grid[rowIndex].append(cell)
                population += cell.isAlive ? 1 : 0
            }
        }
    }
    
    init(grid: [[Cell]]) {
        self.height = grid.count
        self.width = grid[0].count
        
        self.grid = grid
        population = getPopulation(of: self.grid)
    }
    
    func getNeighbors(of cell: Cell) -> [Cell] {
        var neighbors: [Cell] = []

        if !isToroidal {
            for rowIndex in cell.y-1...cell.y+1 {
                for colIndex in cell.x-1...cell.x+1 {
                    if rowIndex >= 0 && rowIndex < height && colIndex >= 0 && colIndex < width {
                        if cell.y != rowIndex || cell.x != colIndex {
                            neighbors.append(grid[rowIndex][colIndex])
                        }
                    }
                }
            }
        } else {
            for rowIndex in cell.y-1...cell.y+1 {
                for colIndex in cell.x-1...cell.x+1 {
                    var row = rowIndex
                    var col = colIndex
                    if row < 0 {
                        row = height - 1
                    } else if row > height - 1 {
                        row = 0
                    }
                    if col < 0 {
                        col = width - 1
                    } else if col > width - 1 {
                        col = 0
                    }
                    if cell.y != rowIndex || cell.x != colIndex {
                        neighbors.append(grid[row][col])
                    }
                }
            }
        }
        
        return neighbors
    }
    
    mutating func advanceGameState() -> Bool {
        var newGrid = grid
        
        var changeDidOccur = false
        
        for (rowIndex, row) in grid.enumerated() {
            for (colIndex, cell) in row.enumerated() {
                let neighbors = getNeighbors(of: cell)
                let aliveNeighbors = neighbors.filter { $0.isAlive }
                if aliveNeighbors.count == 3 || (aliveNeighbors.count == 2 && cell.isAlive) {
                    if !newGrid[rowIndex][colIndex].isAlive {
                        changeDidOccur = true
                        population += 1
                    }
                    newGrid[rowIndex][colIndex].isAlive = true
                } else {
                    if newGrid[rowIndex][colIndex].isAlive {
                        changeDidOccur = true
                        population -= 1
                    }
                    newGrid[rowIndex][colIndex].isAlive = false
                }
            }
        }
        
        if changeDidOccur {
            grid = newGrid
            generation += 1
        }
        
        return changeDidOccur
    }
    
    func getPopulation(of grid: [[Cell]]) -> Int {
        var population = 0
        
        for row in grid {
            for cell in row {
                if cell.isAlive {
                    population += 1
                }
            }
        }
        
        return population
    }
    
    mutating func toggleIsAlive(of cell: Cell) {
        population += cell.isAlive ? -1 : 1
        grid[cell.y][cell.x].isAlive.toggle()
        generation = 0
    }
    
    mutating func toggleIsToroidal() {
        isToroidal.toggle()
    }
}
