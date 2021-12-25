//
//  Day24.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

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
            return z == 1
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
        
        func record(bPosition: String, toAPosition aPosition: String, instructionType: Instruction) {
            let value: Int
            let aValue = valueAFrom(aPosition: aPosition)
            let bValue = valueFrom(bPosition: bPosition)
            switch instructionType {
            case .input:
                 value = bValue
            case .add:
                value = bValue + aValue
            case .mod:
                value = aValue % bValue
            case .div:
                let v1 = Double(aValue) / Double(bValue)
                value = Int(v1.rounded(.down))
            case .mul:
                value = aValue * bValue
            case .eql:
                value = aValue == bValue ? 1 : 0
            }
            switch aPosition {
            case "x":
                x = value
            case "y":
                y = value
            case "z":
                z = value
            case "w":
                w = value
            default:
                fatalError()
            }
        }
        
        func process(instruction: String, code: [Int]) {
            let segments = instruction.components(separatedBy: .whitespaces)
            let instructionFound = Instruction(rawValue: segments.first!)!
            let variableA = segments[1]
            let variableB: String? = segments.count > 2 ? segments[2] : nil
            
            guard instructionFound != .input else {
                // We need to read off our 14 digit code
                let head = code.first!
                record(bPosition: String(head), toAPosition: variableA, instructionType: .input)
                
                return
            }
            guard let realB = variableB else { fatalError() }
            
            record(bPosition: realB, toAPosition: variableA, instructionType: instructionFound)
        }
        
    }
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    override func part1() -> String {
        let sub1 = SubMonad()
        let inputLines = input.lines.raw
        for index in 8..<10 {
            var code = Array(repeating: index, count: 14)
            inputLines.forEach { line -> Void in
                sub1.process(instruction: line, code: code)
            }
            let isValid = sub1.isValid
            print("\(index) is \(isValid)")
        }
        
        return "#function"
    }
    
    override func part2() -> String {
        return "#function"
    }
    
}
