//
//  Cell.swift
//  GameOfLife
//
//  Created by Kevin Roebuck on 4/14/22.
//

import Foundation

struct Cell: Hashable {
    public var x: Int
    public var y: Int
    public var isAlive: Bool
    
//    public func neighbors() -> [Cell] {
//        var neighbors: [Cell] = []
//
//        for yn in y-1...y+1 {
//            for xn in x-1...x+1 {
//                if (x != xn || y != yn) {
//                    neighbors.append(Cell(x: xn, y: yn))
//                }
//            }
//        }
//
//        return neighbors
//    }
}
