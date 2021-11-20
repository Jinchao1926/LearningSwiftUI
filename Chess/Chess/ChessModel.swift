//
//  ChessModel.swift
//  Chess
//
//  Created by 林锦超 on 2021/11/20.
//

import SwiftUI

class ChessModel: ObservableObject {
    @Published private(set) var board: [[ChessItem]] = []
    private(set) var boardSize: Int = 3
    private(set) var currentSetp: ChessItem = .x
    
    private var sumOfStepX: Int { boardSize * ChessItem.x.intValue }
    private var sumOfStepO: Int { boardSize * ChessItem.o.intValue }
    
    private(set) var winner: ChessItem? = nil
    
    //MARK:- LifeCycle
    init(with boardSize: Int = 3) {
        self.boardSize = boardSize
        
        for _ in 0..<boardSize {
            var row: [ChessItem] = []
            
            for _ in 0..<boardSize {
                row.append(.empty)
            }
            board.append(row)
        }
        
        print(board)
    }
    
    //MARK:- Playing
    func playing(atRow row: Int, col: Int) {
        guard row < board.count else { return }
        
        guard col < board[row].count else { return }
        
        board[row][col] = currentSetp
        
        guard judgeWinner() else {
            toggleStep()
            return
        }
        winner = currentSetp
    }
    
    func restart() {
        for (idx, rows) in board.enumerated() {
            for (jdx, _) in rows.enumerated() {
                board[idx][jdx] = .empty
            }
        }
        
        currentSetp = .x
        winner = nil
    }
    
    //MARK:- Private
    private func toggleStep() {
        if currentSetp == .x {
            currentSetp = .o
            return
        }
        
        if currentSetp == .o {
            currentSetp = .x
            return
        }
    }
    
    //
    private func judgeWinner() -> Bool {
        var sumOfRows = 0
        var sumOfCols = 0
        var sumOfLeftDiags = 0  //diagonal
        var sumOfRightDiags = 0
        
        var pending = false
        
        //
        for (idx, rows) in board.enumerated() {
            sumOfRows = 0
            sumOfCols = 0
            
            for (jdx, item) in rows.enumerated() {
                sumOfRows += item.intValue  //board[idx][jdx].intValue
                sumOfCols += board[jdx][idx].intValue
                
                if item == .empty {
                    pending = true
                }
            }
            
            // check rows
            if sumOfRows == sumOfStepX || sumOfCols == sumOfStepX {
                print("X wins!!")
                return true
            }
            // check colums
            if sumOfRows == sumOfStepO || sumOfCols == sumOfStepO {
                print("O wins!!")
                return true
            }
            
            //
            sumOfLeftDiags += board[idx][idx].intValue
            sumOfRightDiags += board[idx][boardSize - 1 - idx].intValue
        }
        
        // check left diagonals
        if sumOfLeftDiags == sumOfStepX || sumOfRightDiags == sumOfStepX {
            print("X wins!!")
            return true
        }
        // check right diagonals
        if sumOfLeftDiags == sumOfStepO || sumOfRightDiags == sumOfStepO {
            print("O wins!!")
            return true
        }
        
        //
        if pending {
            return false
        }
        print("Nobody wins!!")
        return false
    }
}

