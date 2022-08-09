//
//  GameBoard.swift
//  GameOfLife
//
//  Created by Kevin Roebuck on 4/20/22.
//

import SwiftUI

struct GameBoard: View {
    @ObservedObject var game: GameViewModel
    
    //
    // Magnification gesture
    //
    
    @State private var scale = 1.0
    @State private var lastScale = 1.0
    
    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { state in
                withAnimation {
                    adjustScale(from: state)
                }
            }
            .onEnded { state in
                withAnimation {
                    validateScaleLimits()
                }
                lastScale = 1.0
            }
    }
    
    func adjustScale(from state: MagnificationGesture.Value) {
        let delta = state / lastScale
        scale *= delta
        lastScale = state
    }
    
    func getMinScaleAllowed() -> CGFloat {
        max(scale, GameBoardConstants.minMagScale)
    }
    
    func getMaxScaleAllowed() -> CGFloat {
        min(scale, GameBoardConstants.maxMagScale)
    }
    
    func validateScaleLimits() {
        scale = getMinScaleAllowed()
        scale = getMaxScaleAllowed()
    }
    
    //
    // Reset gesture
    //
    
    var resetGesture: some Gesture {
        LongPressGesture(minimumDuration: GameBoardConstants.minResetPressDuration, maximumDistance: 0)
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    scale = 1.0
                    lastScale = 1.0
                }
            }
    }
    
    //
    // Drag gesture
    //
    
    @State private var offset: CGSize = .zero
    @State private var newset: CGSize = .zero
    @State private var isDragging = false
    
    var drag: some Gesture {
        let dragGesture = DragGesture(minimumDistance: GameBoardConstants.minDragDistance, coordinateSpace: .local)
            .onChanged { drag in
                withAnimation(.spring()) {
                    offset = CGSize(
                        width: drag.translation.width + newset.width,
                        height: drag.translation.height + newset.height
                    )
                }
            }
            .onEnded { _ in
                newset = offset
                isDragging = false
            }
        
        let pressGesture = LongPressGesture(minimumDuration: GameBoardConstants.minDragPressDuration)
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }
        
        let combined = pressGesture.sequenced(before: dragGesture)
        
        return combined
    }
    
    // Return cell at the specified location, if one is there.
    func getCell(at location: CGPoint, in size: CGSize, cellSize: CGFloat) -> Cell? {
        // The canvas will zoom about the center point:
        let zoomPoint = CGPoint(x: size.width / 2, y: size.height / 2)

        // The vector pointing from zoom point to drag location.
        // Undo any offset from dragging by subtracting offset.
        // Undo any magnification effects by dividing by scale.
        let xFromZoomPointNormalized = (location.x - offset.width - zoomPoint.x) / scale
        let yFromZoomPointNormalized = (location.y - offset.height - zoomPoint.y) / scale
        
        // Click location divided by cellSize to get corresponding row/column
        let xFloat = (zoomPoint.x + xFromZoomPointNormalized) / cellSize
        let yFloat = (zoomPoint.y + yFromZoomPointNormalized) / cellSize
        if xFloat < 0 || yFloat < 0 { return nil } // avoid casting values in (-1, 0) to 0.
        let x = Int(xFloat)
        let y = Int(yFloat)
        if x >= game.width || y >= game.height { return nil }

        // Find cell clicked on, if any
        for (rowIndex, row) in game.grid.enumerated() {
            if rowIndex == y {
                for cell in row {
                    if cell.x == x && cell.y == y {
                        return cell
                    }
                }
            }
        }
        
        return nil
    }
    
    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { timeline in
                var gridWidth: CGFloat = 0
                var gridHeight: CGFloat = 0
                
                HStack {
                    let cellSize = min(geometry.size.width / CGFloat(game.width), geometry.size.height / CGFloat(game.height))
                    
                    // Without this spacer, the grid will be left/top-aligned in the parent view
                    let marginWidth = (geometry.size.width - cellSize * CGFloat(game.width)) / 2
                    let marginHeight = (geometry.size.height - cellSize * CGFloat(game.height)) / 2
                    Spacer(minLength: marginWidth)
                    
                    VStack {
                        Spacer(minLength: marginHeight)
                        
                        Canvas { context, size in
                            gridWidth = cellSize * CGFloat(game.width)
                            gridHeight = cellSize * CGFloat(game.height)
                            
                            for row in game.grid {
                                for cell in row {
                                    let xPos = cellSize * CGFloat(cell.x)
                                    let yPos = cellSize * CGFloat(cell.y)
                                    let cellRect = CGRect(x: xPos, y: yPos, width: cellSize, height: cellSize)
                                    context.fill(
                                        Path(roundedRect: cellRect, cornerRadius: 0),
                                        with: .color(
                                            GameBoardConstants.cellColor
                                                .opacity(
                                                    cell.isAlive ? GameBoardConstants.cellOpacityAlive : GameBoardConstants.cellOpacityDead
                                                )
                                        )
                                    )
                                    context.stroke(
                                        Path(roundedRect: cellRect, cornerRadius: 0),
                                        with: .color(.black)
                                    )
                                }
                            }
                        }
                        .scaleEffect(scale)
                        .gesture(magnification)
                        .offset(offset)
                        .simultaneousGesture(drag)
                        .simultaneousGesture(resetGesture)
                        .simultaneousGesture( // Click cell to toggle 'isAlive' status
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onEnded { drag in
                                    if !isDragging {
                                        // Where click gesture began
                                        let startCell = getCell(
                                            at: CGPoint(x: drag.startLocation.x, y: drag.startLocation.y),
                                            in: CGSize(width: gridWidth, height: gridHeight),
                                            cellSize: cellSize
                                        )
                                        // Where click gesture ended
                                        let endCell = getCell(
                                            at: CGPoint(x: drag.location.x, y: drag.location.y),
                                            in: CGSize(width: gridWidth, height: gridHeight),
                                            cellSize: cellSize
                                        )
                                        // If same cell, toggle isAlive
                                        if startCell != nil && endCell != nil {
                                            if startCell!.x == endCell!.x && startCell!.y == endCell!.y {
                                                game.toggleValue(of: endCell!)
                                            }
                                        }
                                    }
                            }
                        )
                        Spacer(minLength: marginHeight)
                    }
                    Spacer(minLength: marginWidth)
                }
            }
        }
    }
    
    private struct GameBoardConstants {
        // magnification
        static let minMagScale: CGFloat  = 1.0
        static let maxMagScale: CGFloat  = 5.0
        
        // reset
        static let minResetPressDuration: CGFloat  = 1.00
        
        // drag
        static let minDragPressDuration: CGFloat  = 0.075
        static let minDragDistance: CGFloat = 5
        
        // canvas
        static let cellColor: Color = .mint
        static let cellOpacityAlive: Double = 0.75
        static let cellOpacityDead: Double = 0.15
    }
}

struct GameBoard_Previews: PreviewProvider {
    static var previews: some View {
        GameBoard(game: GameViewModel())
    }
}

