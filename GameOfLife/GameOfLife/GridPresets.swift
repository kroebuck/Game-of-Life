//
//  GridPresets.swift
//  GameOfLife
//
//  Created by Kevin Roebuck on 4/26/22.
//

import Foundation

struct GridPresets {
    static let welcomeScreenGrid = [
        [false, false, false, false, false, false, false, false, false],
        [false, false, false, false, false, false, false, false, false],
        [false, false, false, false, false, false, false, false, false],
        [false, false, false, false, true, false, false, false, false],
        [false, false, false, true, true, true, false, false, false],
        [false, false, false, false, false, false, false, false, false],
        [false, false, false, false, false, false, false, false, false],
        [false, false, false, false, false, false, false, false, false],
        [false, false, false, false, false, false, false, false, false],
    ]
    
    //
    
    static let tooFewNeighbors = [
        [true, false, false],
        [false, true, false],
        [false, false, false]
    ]
    
    static let tooFewNeighborsNext = [
        [false, false, false],
        [false, false, false],
        [false, false, false]
    ]
    
    //
    
    static let tooManyNeighbors = [
        [true, false, true],
        [true, true, false],
        [false, true, true]
    ]
    
    static let tooManyNeighborsNext = [
        [true, false, false],
        [true, false, false],
        [true, true, true]
    ]
    
    //
    
    static let twoNeighbors = [
        [true, false, false],
        [false, true, false],
        [false, true, false]
    ]
    
    static let twoNeighborsNext = [
        [false, false, false],
        [true, true, false],
        [false, false, false]
    ]
    
    //
    
    static let emptyThreeNeighbors = [
        [true, false, false],
        [true, false, false],
        [false, false, true]
    ]
    
    static let emptyThreeNeighborsNext = [
        [false, false, false],
        [false, true, false],
        [false, false, false]
    ]
    
    //
    
    static let gliderGun = [
        [false, false, false, false, false, false, false, false, false, false],
        [false, false, true, false, false, false, false, false, false, false],
        [false, false, false, true, false, false, false, false, false, false],
        [false, true, true, true, false, false, false, false, false, false],
        [false, false, false, false, false, false, false, false, false, false],
        [false, false, false, false, false, false, false, false, false, false],
        [false, false, false, false, false, false, false, false, false, false],
        [false, false, false, false, false, false, false, false, false, false],
        [false, false, false, false, false, false, false, false, false, false],
        [false, false, false, false, false, false, false, false, false, false]
    ]
}
