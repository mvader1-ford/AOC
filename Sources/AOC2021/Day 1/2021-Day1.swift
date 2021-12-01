//
//  Day1.swift
//
//  Created by Dave DeLong on 11/28/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

class Day1: Day {
  
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
