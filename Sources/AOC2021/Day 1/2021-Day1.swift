//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 11/28/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

//mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
//trh fvjkl sbzzf mxmxvkd (contains dairy)
//sqjhc fvjkl (contains soy)
//sqjhc mxmxvkd sbzzf (contains fish)

typealias Deck = [Int]

class Day1: Day {
    
    struct Depth: Sequence, IteratorProtocol {
        
        typealias Element = Int
        
        let measurements: [Int]
        
        var currentIndex = 0
        
        mutating func next() -> Int? {
            let proposedIndex = currentIndex + 1
            guard proposedIndex < measurements.count else { return nil }
            
            defer {
                currentIndex += 1
            }
            
            return measurements[proposedIndex]
        }
        
    }
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    
    override func part1() -> String {
        let array1 = input.integers
        let offsetArray1 = [0] + array1
        let zippedArray1 = zip(offsetArray1, array1)
        var counter1 = 0
        let offsetArrayDroppingLast1 = Array(zippedArray1.dropFirst())
        for item in offsetArrayDroppingLast1 {
            if item.1 - item.0 > 0 {
                counter1 += 1
            }
        }
        
        return String(counter1)
    }
    
    override func part2() -> String {
        let array = input.integers
        let offsetArray = [0] + array
        let zippedArray = zip(offsetArray, array)
        var counter = 0
        let offsetArrayDroppingLast = Array(zippedArray.dropFirst())
        let chunked1 = array.chunks(of: 3)
        let pick1 = array.takeThree(startPickPointRange: 0)
//        print(pick1)
        let indices = array.enumerated().map{ $0.0 }
        let stuff = indices.map{ array.takeThree(startPickPointRange: $0) }.compactMap{ $0 }
        let sums = stuff.map { $0.sum }
        
        let array1 = sums
        let offsetArray1 = [0] + array1
        let zippedArray1 = zip(offsetArray1, array1)
        var counter1 = 0
        let offsetArrayDroppingLast1 = Array(zippedArray1.dropFirst())
        for item in offsetArrayDroppingLast1 {
            if item.1 - item.0 > 0 {
                counter1 += 1
            }
        }
        
        return String(counter1)
    }
    
}

extension Array {
    
    func takeThree(startPickPointRange: Int) -> Array? {
        let endPickPointRange = startPickPointRange + 2
        guard endPickPointRange < count else { return nil }
        let answer = Array(self[startPickPointRange...endPickPointRange])
        
        return answer
    }
    
}
