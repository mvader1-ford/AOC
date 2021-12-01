//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 11/28/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

//mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
//trh fvjkl sbzzf mxmxvkd (contains dairy)
//sqjhc fvjkl (contains soy)
//sqjhc mxmxvkd sbzzf (contains fish)

typealias Deck = [Int]

class Day1: Day {
    
    struct Game: Sequence, IteratorProtocol {
        
        var table: Table
        var previousRound1 = [Deck]()
        var previousRound2 = [Deck]()
        var round = 1
        let gameNumber: Int
        
        init(table: Table) {
            self.table = table
            self.gameNumber = 1
        }
        
        mutating func findRoundWinner() -> String {
//            print("Evaluating round \(round) of \(totalGameCounter)")
            if round == 13 {
                let a = 123
            }
            let winner: String
            if previousRound1.contains(table.allDeck1) || previousRound2.contains(table.allDeck2) {
                winner = "1"
            } else if table.isReadyForRecursive {
                let newDeck1: Deck = Array(table.deck1[1..<table.player1Card])
                let newDeck2: Deck = Array(table.deck2[1..<table.player2Card])
                let player1Card = table.deck1.first!
                let player2Card = table.deck2.first!
                let newTable = Table(player1Card: player1Card, player2Card: player2Card, deck1: newDeck1, deck2: newDeck2)
                var newGame = Game(table: newTable)
                var updatedWinner = ""
                for i in newGame {
                    //                    updatedWinner = newGame.findRoundWinner()
                    round += 1
                }
                winner = updatedWinner
            } else {
                winner = table.player1Card > table.player2Card ? "1" : "2"
            }
            
            //            switch (totalGameCounter, round) {
            //            case (1, 1):
            //                if table.allDeck1.count == 5 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //            case (1, 2):
            //                if table.allDeck1.count == 6 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //            case (1, 9):
            //                if table.allDeck1.count == 5 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //                if table.allDeck2.count == 5 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //            case (1, 10):
            //                if table.allDeck1.count == 4 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //                if table.allDeck2.count == 6 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //            case (1, 12):
            //                if table.allDeck1.count == 4 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //                if table.allDeck2.count == 6 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //            case (3, 4):
            //                if table.allDeck1.count == 1 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //                if table.allDeck2.count == 7 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //            case (1, 13):
            //                if table.allDeck1.count == 3 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //                if table.allDeck2.count == 7 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //            case (1, 14):
            //                if table.allDeck1.count == 2 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //                if table.allDeck2.count == 8 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //            case (1, 15):
            //                if table.allDeck1.count == 3 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //                if table.allDeck2.count == 7 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //            case (1, 17):
            //                if table.allDeck1.count == 1 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //                if table.allDeck2.count == 9 {
            //
            //                } else {
            //                    fatalError()
            //                }
            //            default:
            //                break
            //            }
            //
            return winner
        }
        
        
        mutating func next() -> Day1.Table? {
            guard table.player1Card > 0 && table.player2Card > 0 else {
                return nil
            }
            let nextDeck1 = Array(table.deck1.dropFirst())
            let nextDeck2 = Array(table.deck2.dropFirst())
            let nextDeck1VictoryPile: Deck
            let nextDeck2VictoryPile: Deck
            
            let winner: String = findRoundWinner()
            round += 1
            
            let winnersPile = winner == "1" ? [table.player1Card, table.player2Card] :  [table.player2Card, table.player1Card]
            
            switch winner {
            case "1":
                nextDeck1VictoryPile = nextDeck1 + winnersPile
                nextDeck2VictoryPile = nextDeck2
            default:
                nextDeck2VictoryPile = nextDeck2 + winnersPile
                nextDeck1VictoryPile = nextDeck1
            }
            
            let nextPlayer1Card = table.deck1.first ?? 0
            let nextPlayer2Card = table.deck2.first ?? 0
            
            let nextTable = Table(player1Card: nextPlayer1Card, player2Card: nextPlayer2Card, deck1: nextDeck1VictoryPile, deck2: nextDeck2VictoryPile)
            previousRound1.append(table.allDeck1)
            previousRound2.append(table.allDeck2)
            defer {
                table = nextTable
            }
            
            return nextTable
        }
        
    }
    
    struct Table {
        
        let player1Card: Int
        let player2Card: Int
        let deck1: Deck
        let deck2: Deck
        
        var allDeck1: Deck {
            return [player1Card].filter{ $0 > 0 } + deck1
        }
        
        var score1: Int {
            return self.scoreFor(deck: allDeck1)
        }
        
        var score2: Int {
            return self.scoreFor(deck: allDeck2)
        }
        
        var allDeck2: Deck {
            return [player2Card].filter{ $0 > 0 } + deck2
        }
        
        var isReadyForRecursive: Bool {
            guard player1Card != 0 else { return false }
            guard player2Card != 0 else { return false }
            let answer = player1Card <= deck1.count && player2Card <= deck2.count
            
            return answer
        }
        
        func scoreFor(deck: Deck) -> Int {
            var total = 0
            let reversedDeck = Array(deck.reversed())
            for (index, card) in reversedDeck.enumerated() {
                total += card * (index + 1)
            }
            return total
        }
    }
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    var player1Cards = [Int]()
    var player2Cards = [Int]()
    
    override func part1() -> String {
        setupDecks()
        let deck1 = Array(player1Cards.dropFirst())
        let deck2 = Array(player2Cards.dropFirst())
        let startingTable = Table(player1Card: player1Cards.first!, player2Card: player2Cards.first!, deck1: deck1, deck2: deck2)
        let game = Game(table: startingTable)
        var runningTable = startingTable
        var counter = 1
        
        for i in game {
            runningTable = i
//            print("AllDeck2 is \(runningTable.allDeck2)")
            counter += 1
        }
        
        let score1 = runningTable.scoreFor(deck: runningTable.allDeck1)
        let score2 = runningTable.scoreFor(deck: runningTable.allDeck2)
        let maxScore = max(score1, score2)
        return String(maxScore)
    }
    
    override func part2() -> String {
        return ""
    }
    
    func setupDecks() {
        var player1Cards = [String]()
        var shouldMakePlayer1 = true
        for line in input.lines.raw {
            if !line.isEmpty {
                if line == "Player 2:" {
                    shouldMakePlayer1 = false
                }
                if shouldMakePlayer1 && line != "Player 1:" {
                    player1Cards.append(line)
                }
            }
        }
        
        self.player1Cards = player1Cards.map{ Int($0)! }
        var shouldMakePlayer2 = false
        var player2Cards = [String]()
        for line in input.lines.raw {
            if !line.isEmpty {
                if line == "Player 2:" {
                    shouldMakePlayer2 = true
                }
                if shouldMakePlayer2 && line != "Player 2:" {
                    player2Cards.append(line)
                }
            }
        }
        self.player2Cards = player2Cards.map{ Int($0)! }
    }
    
}
