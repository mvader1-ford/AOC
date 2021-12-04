//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore
import Combine

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}



class Day4: Day {
    
    struct Square {
        
        let x: Int
        let y: Int
        let bit: Bit
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(x)
            hasher.combine(y)
            hasher.combine(bit)
        }
    }
    
    typealias Board = [[Int]]
    
    lazy var drawnNumbers: [Int] = {
        return input.lines.first!.integers
    }()
    
    
    func updateBoardWithNumber(board: Matrix<Int>, number: Int) -> Matrix<Int> {
        let data = board.data
            .map { localArray in
                return localArray.map{ localValue -> Int in
                    return localValue == number ? 999 : localValue
                }
            }
        
        return Matrix(data)
    }
    
    func isWinnerFor(board: Matrix<Int>) -> Bool {
        var isWinner = false
        for row in 0..<board.rowCount {
            let rowMatches = board.row(row).filter{ $0 == 999 }.count
            if rowMatches == board.colCount {
                isWinner = true
            }
        }
        
        for column in 0..<board.colCount {
            let columnMatches = board.column(column).filter{ $0 == 999 }.count
            if columnMatches == board.rowCount {
                isWinner = true
            }
        }
        
        
        return isWinner
    }
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    
    
    override func part1() -> String {
        
        
        let a1 = drawnNumbers
        let a2 = input.lines[2].integers
        let boards = Array(input.lines.dropFirst())
            .map{ $0.integers }
            .filter{ !$0.isEmpty }
            .chunked(into: 5)
        
        var matrices = boards.map{ Matrix($0) }
        let firstBoard = matrices.first!
        let firstColumn = firstBoard.column(0)
        
        var isWinner = false
        var winCounter = 0
        for number in drawnNumbers {
            if isWinner {
                
            } else {
                var updatedBoards = matrices.map{ updateBoardWithNumber(board: $0, number: number)}
                for board in updatedBoards {
                    let boardDidWin = isWinnerFor(board: board)
                    if boardDidWin {
                        isWinner = true
                        print("Number drawn is \(number)")
                        var localSums = 0
                        
                        let data = board.data
                            .map { localArray in
                                return localArray.map{ localValue -> Int in
                                    if localValue != 999 {
                                        localSums += localValue
                                    }
                                    return localValue
                                }
                            }
                        let winningNumber = number
                        let product = localSums * winningNumber
                        winCounter = product
                    }
                }
                matrices = updatedBoards
            }
            
        }

        let markedOnes = winCounter
        
        return String(winCounter)
    }
    
    override func part2() -> String {
        
        var isAllDone = false
        let a1 = drawnNumbers
        let a2 = input.lines[2].integers
        let boards = Array(input.lines.dropFirst())
            .map{ $0.integers }
            .filter{ !$0.isEmpty }
            .chunked(into: 5)
        
        var matrices = boards.map{ Matrix($0) }
        let firstBoard = matrices.first!
        let firstColumn = firstBoard.column(0)
        var winningBoardCount = 0
        var boardsThatWon = Set<Int>()
        var isWinner = false
        var winCounter = 0
        for number in drawnNumbers {
            if boardsThatWon.count == matrices.count {
                
            } else {
                var updatedBoards = matrices.map{ updateBoardWithNumber(board: $0, number: number)}
                for (indexBoard, board) in updatedBoards.enumerated() {
                    if isAllDone {
                        
                    } else {
                        let boardDidWin = isWinnerFor(board: board)
                        if boardDidWin {
                            boardsThatWon.insert(indexBoard)
                            winningBoardCount += 1
                            if boardsThatWon.count == matrices.count {
                                isWinner = true
                                print("Number drawn is \(number)")
                                var localSums = 0
                                
                                let data = board.data
                                    .map { localArray in
                                        return localArray.map{ localValue -> Int in
                                            if localValue != 999 {
                                                localSums += localValue
                                            }
                                            return localValue
                                        }
                                    }
                                let winningNumber = number
                                let product = localSums * winningNumber
                                winCounter = product
                                isAllDone = true
                            }
                       
                        }
                 
                    }
                  
                }
                matrices = updatedBoards
            }
            
        }

        let markedOnes = winCounter
        
        return String(winCounter)
    }
    
}
