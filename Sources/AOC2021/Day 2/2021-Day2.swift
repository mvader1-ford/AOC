//
//  Day2.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import CoreGraphics
import simd

class Day2: Day {
    
    struct SubLocale {
        
        let aim: CGFloat
        let position: CGPoint
        
    }
    
    enum Instruction: String {
        
        case forward
        case down
        case up
        
    }
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    override func part1() -> String {
        let instructions = input.lines.words
        let instructionPairs = instructions.map{ wordPair -> (Instruction, Int) in
            let direction = Instruction(rawValue: wordPair.first!.raw)!
            let value = wordPair.last!.integer!
            
            return (direction, value)
        }
        
        let depth = instructionPairs.reduce(CGPoint.zero) { rollingValue, wordPair -> CGPoint in
            let valueFound = CGFloat(wordPair.1)
            switch wordPair.0 {
            case .forward:
                let currentX = rollingValue.x + valueFound
                
                return CGPoint(x: currentX, y: rollingValue.y)
            case .down:
                let currentY = rollingValue.y + valueFound
                
                return CGPoint(x: rollingValue.x, y: currentY)
            case .up:
                let currentY = rollingValue.y - valueFound
                
                return CGPoint(x: rollingValue.x, y: currentY)
            }
        }
        
        let factor = depth.x * depth.y
        
        return String(Int(factor))
    }
    
    override func part2() -> String {
        let position = CGPoint(x: 0, y: 0)
        let instructions = input.lines.words
        let instructionPairs = instructions.map{ wordPair -> (Instruction, Int) in
            let direction = Instruction(rawValue: wordPair.first!.raw)!
            let value = wordPair.last!.integer!
            
            return (direction, value)
        }
        let startingLocale = SubLocale(aim: 0, position: .zero)
        let depth = instructionPairs.reduce(startingLocale) { rollingValue, wordPair -> SubLocale in
            let valueFound = CGFloat(wordPair.1)
            switch wordPair.0 {
            case .forward:
                let depth = rollingValue.aim * valueFound
                let currentX = rollingValue.position.x + valueFound
                let updatedPosition = CGPoint(x: currentX, y: rollingValue.position.y + depth)
                
                return SubLocale(aim: rollingValue.aim, position: updatedPosition)
            case .down:
                return SubLocale(aim: rollingValue.aim + valueFound, position: rollingValue.position)
            case .up:
                return SubLocale(aim: rollingValue.aim - valueFound, position: rollingValue.position)
            }
        }
        
        let factor = depth.position.x * depth.position.y
        
        return String(Int(factor))
    }
    
}
