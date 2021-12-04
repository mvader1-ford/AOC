//
//  Day3.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//
extension String {
    subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
}
class Day3: Day {
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    func buildColumnsFrom(data: [[Int]]) -> [[Int]] {
        guard !data.isEmpty else { return [[]] }
        guard let firstItem = data.first, !firstItem.isEmpty else { return [[]] }
        let firstColumn = data.map{ $0.first! }
        let tail = data.map{ Array($0.dropFirst()) }
        
        return [firstColumn] + buildColumnsFrom(data: tail)
    }
    
    override func part1() -> String {
        let mappedItems = input.lines.map{ $0.characters }
        var data = [[Int]]()
        
        mappedItems.forEach { row in
            var thisRow = [Int]()
            row.forEach { column in
                let intValue = Int(String(column))
                thisRow.append(intValue!)
            }
            data.append(thisRow)
        }
        let all = buildColumnsFrom(data: data).filter{ !$0.isEmpty }
        let work = buildColumnsFrom(data: data).first!
        let mappedItems123 = work.map { ($0, 1) }
        let counts = Dictionary(mappedItems123, uniquingKeysWith: +)
        
        let winners = all.map{ c1 -> Int in
            let mappedItems44 = c1.map { ($0, 1) }
            let cFun = Dictionary(mappedItems44, uniquingKeysWith: +)
            
            let sorted = cFun.sorted{ $0.value > $1.value }.map{ $0.key }
            
            return sorted.first ?? 0
        }
        
        let gammaRateString = winners.reduce("") { rollingResult, intPassed in
            return rollingResult + String(intPassed)
        }
        
        let epsilonRateString = winners.reduce("") { rollingResult, intPassed in
            let updatedValue = intPassed == 1 ? 0 : 1
            
            return rollingResult + String(updatedValue)
        }
        
        let binary = gammaRateString
        guard let gammaRate = Int(binary, radix: 2), let epsilon = Int(epsilonRateString, radix: 2) else {
            fatalError()
        }
        let total = gammaRate * epsilon
        //        let gamma1 =
        return String(total)
    }
    
    func findOxygenFrom(data:[[Int]], isOxy: Bool = true) -> Int {
       
        //o2
        var oxyData = data
        var counter = 0
        while oxyData.count > 1 {
            let work = buildColumnsFrom(data: oxyData)[counter]
            let mappedItems123 = work.map { ($0, 1) }
            let counts = Dictionary(mappedItems123, uniquingKeysWith: +)
            let sorted : [Int]
            if isOxy {
             sorted = counts.sorted{ $0.value > $1.value }.map{ $0.key }
            } else {
                sorted = counts.sorted{ $0.value < $1.value }.map{ $0.key }
            }
            let realChosen: Int
            if counts[0] == counts[1] {
             
                realChosen = isOxy ? 1 : 0
            } else {
                realChosen = sorted.first ?? 0
            }
            oxyData = oxyData.filter { someNumber -> Bool in
               let stringValue = someNumber.reduce("") { rollingResult, intPassed in
                    return rollingResult + String(intPassed)
                }
                let chosenFound = String(stringValue[counter])
                
                return chosenFound == String(realChosen)
            }
            
            counter += 1
        }
        
        let oxygenThing = oxyData.first!.reduce("") { rollingResult, intPassed in
            return rollingResult + String(intPassed)
        }
        guard let oxygenRank = Int(oxygenThing, radix: 2) else { fatalError() }
        
        return oxygenRank
    }
    
    override func part2() -> String {
        let mappedItems = input.lines.map{ $0.characters }
        var data = [[Int]]()
        
        mappedItems.forEach { row in
            var thisRow = [Int]()
            row.forEach { column in
                let intValue = Int(String(column))
                thisRow.append(intValue!)
            }
            data.append(thisRow)
        }
        let answer15125 = findOxygenFrom(data: data)
        let c02Rank = findOxygenFrom(data: data, isOxy: false)
let lifeSUpport = answer15125 * c02Rank
        return String(lifeSUpport)
    }
    
}
