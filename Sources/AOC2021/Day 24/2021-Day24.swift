//
//  Day24.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import os
enum BadMath: Error {
    
    case tooBig
    
}

class Day24: Day {
    
    //    inp a - Read an input value and write it to variable a.
    //    add a b - Add the value of a to the value of b, then store the result in variable a.
    //    mul a b - Multiply the value of a by the value of b, then store the result in variable a.
    //    div a b - Divide the value of a by the value of b, truncate the result to an integer, then store the result in variable a. (Here, "truncate" means to round the value toward zero.)
    //    mod a b - Divide the value of a by the value of b, then store the remainder in variable a. (This is also called the modulo operation.)
    //    eql a b - If the value of a and b are equal, then store the value 1 in variable a. Otherwise, store the value 0 in variable a.
    
    //    inp w
    //    add z w
    //    mod z 2
    //    div w 2
    //    add y w
    //    mod y 2
    //    div w 2
    //    add x w
    //    mod x 2
    //    div w 2
    //    mod w 2
    
    enum Instruction: String {
        
        case input = "inp"
        case add = "add"
        case mod = "mod"
        case div = "div"
        case mul = "mul"
        case eql = "eql"
        
        func execute(a: Int, b: Int?, subMonad: inout SubMonad) {
            
        }
        
    }
    
    final class SubMonad {
        
        var x: Int = 0
        var y: Int = 0
        var z: Int = 0
        var w: Int = 0
        
        var isValid: Bool {
            return z == 0
        }
        
//        var code: [Int] = Array(repeating: 1, count: 14)// [9,3,5,7,9,2,4,6,8,9,9,9,9,9]
        
        func valueAFrom(aPosition: String) -> Int {
            switch aPosition {
            case "x":
                return x
            case "y":
                return y
            case "z":
                return z
            case "w":
                return w
            default:
                fatalError()
            }
        }
        
        func valueFrom(bPosition: String) -> Int {
            guard let intValue = Int(bPosition) else {
                switch bPosition {
                case "x":
                    return x
                case "y":
                    return y
                case "z":
                    return z
                case "w":
                    return w
                default:
                    fatalError()
                }
            }
            
            return intValue
        }
        
        
        //    inp a - Read an input value and write it to variable a.
        //    add a b - Add the value of a to the value of b, then store the result in variable a.
        //    mul a b - Multiply the value of a by the value of b, then store the result in variable a.
        //    div a b - Divide the value of a by the value of b, truncate the result to an integer, then store the result in variable a. (Here, "truncate" means to round the value toward zero.)
        //    mod a b - Divide the value of a by the value of b, then store the remainder in variable a. (This is also called the modulo operation.)
        //    eql a b - If the value of a and b are equal, then store the value 1 in variable a. Otherwise, store the value 0 in variable a.
        
        func record(bPosition: String, toAPosition aPosition: String, instructionType: Instruction, count: Int) throws {
            guard z < 1000 else { return }
            let value: (Int, Bool)
            let aValue = valueAFrom(aPosition: aPosition)
            let bValue = valueFrom(bPosition: bPosition)
            switch instructionType {
            case .input:
                 value = (bValue, false)
             
//                os_log("Index %@.....  x %@, y %@, z %@, w %@ ", log: .default, type: .info, NSNumber(value: count), NSNumber(value: x), NSNumber(value: y), NSNumber(value: z), NSNumber(value: bValue))
            case .add:
                value = bValue.addingReportingOverflow(aValue)
            case .mod:
                value = aValue.remainderReportingOverflow(dividingBy: bValue)
            case .div:
                let v1 = aValue.dividedReportingOverflow(by: bValue)
                let doubleV1 = Double(v1.0)
                value = (Int(doubleV1.rounded(.down)), v1.1)
            case .mul:
                value = aValue.multipliedReportingOverflow(by: bValue)
            case .eql:
                value = aValue == bValue ? (1, false) : (0, false)
            }
            
            guard !value.1 else {
//                return
//                os_log("Overflowing %@ %@", log: .default, type: .info,aPosition,  bPosition)


                throw BadMath.tooBig
                switch aPosition {
                case "x":
                    x = 1
                case "y":
                    y = 1
                case "z":
                    z = 1
                case "w":
                    w = 1
                default:
                    fatalError()
                }
                return
            }
            switch aPosition {
            case "x":
                x = value.0
            case "y":
                y = value.0
            case "z":
                z = value.0
            case "w":
                w = value.0
            default:
                fatalError()
            }
        }
        
        func process(instruction: String, code: [Int], count: Int) throws {
            let segments = instruction.components(separatedBy: .whitespaces)
            let instructionFound = Instruction(rawValue: segments.first!)!
            let variableA = segments[1]
            let variableB: String? = segments.count > 2 ? segments[2] : nil
            
            guard instructionFound != .input else {
                // We need to read off our 14 digit code
                let head = code.first!
                try record(bPosition: String(head), toAPosition: variableA, instructionType: .input, count: count)
                
                return
            }
            guard let realB = variableB else { fatalError() }
            
            try record(bPosition: realB, toAPosition: variableA, instructionType: instructionFound, count: count)
        }
        
    }
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    override func part1() -> String {
        let sub1 = SubMonad()
        let inputLines = input.lines.raw
//        let starterSet = [9,0,0,0,0,0,0,0,0,0,0,0,0,0]
//        let allStarters = [starterSet] //starterSet.permutations(ofCount: 14)
        
        let checkMe = [9,9,9,9,9,9,9,9,9,9,9,9,5,8]
        let xOriginal = 0
        let yOriginal = 0
        let zOriginal = 0
        let wOriginal = 0

        let digitSet = Set([1,2,3,4,5,6,7,8,9])
        let nineOrMore = Set([9])
        let fiveOrMore = Set([5,6,7,8,9])
        let sevenOrMore = Set([7,8,9])
        let eightOrMore = Set([8,9])
                
        for index in 0..<100000 {
//            var code = [digitSet.randomElement()!, digitSet.randomElement()!,digitSet.randomElement()!, digitSet.randomElement()!, digitSet.randomElement()!, digitSet.randomElement()!,digitSet.randomElement()!,digitSet.randomElement()!, digitSet.randomElement()!, digitSet.randomElement()!, digitSet.randomElement()!, digitSet.randomElement()!, digitSet.randomElement()!, digitSet.randomElement()!]
            var code = [digitSet.randomElement()!]
            let validAnswer = code
            // let code = Array.init(repeating: 0, count: 14)
            
            //x = w + 11 - 26
            autoreleasepool {
                sub1.x = digitSet.randomElement()!
                sub1.y = 0
                sub1.z = 0
                sub1.w = sub1.x + 15
                inputLines.enumerated().forEach { (counter, line) -> Void in
                    do {
                        try sub1.process(instruction: line, code: code, count: counter)
                        if line.contains("inp") {
                            code = Array(code.dropFirst())
                        }
                    } catch {
                        sub1.z = 42
                    }
                }
            }
            if sub1.isValid {
                os_log("This code worked %@", log: .default, type: .info, validAnswer)
            } else {
//                os_log("Failed worked %@", log: .default, type: .info, validAnswer)
            }
            
        }
        
        
        return "#function"
    }
    
    override func part2() -> String {
        return "#function"
    }
    
}
