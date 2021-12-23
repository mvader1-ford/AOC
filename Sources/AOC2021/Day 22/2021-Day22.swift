//
//  Day22.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

class Day22: Day {
    
    struct LightsOn: Sequence, IteratorProtocol {
        
        mutating func next() -> Set<Vector3>? {
            return nil
        }
        
        
        typealias Element = Set<Vector3>
        
        var current = 1
        
        mutating func next() -> Int? {
            defer {
                current *= 2
            }
            
            return current
        }
        
        let points: Set<Vector3>
        
        func adding(_ other: LightsOn) -> LightsOn {
            let updatedPoints = points.union(other.points)
            
            return LightsOn(points: updatedPoints)
        }

        func subtracting(_ other: LightsOn) -> LightsOn {
            let updatedPoints = points.filter{ !other.points.contains($0) }
            
            return LightsOn(points: updatedPoints)
        }
   
    }
    
    class LineData {
        
        let xMin: Int
        let xMax: Int
        let yMin: Int
        let yMax: Int
        let zMin: Int
        let zMax: Int
        let offOn: Int
        
        init(xMin: Int,
              xMax: Int,
              yMin: Int,
              yMax: Int,
              zMin: Int,
              zMax: Int,
              offOn: Int) {
            self.xMax = xMax
            self.yMax = yMax
            self.zMax = zMax
            self.xMin = xMin
            self.yMin = yMin
            self.zMin = zMin
            self.offOn = offOn
        }

        lazy var points: Set<Vector3> = {
            var points = Set<Vector3>()
            for x in xMin...xMax {
                for y in yMin...yMax {
                    for z in zMin...zMax {
                        points.insert(Vector3(x: x, y: y, z: z))
                    }
                }
            }
            return points
        }()
  
    }
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    func isValid(point: Point3) -> Bool {
        guard point.x >= -50 else { return false }
        guard point.x <= 50 else { return false }
        guard point.y >= -50 else { return false }
        guard point.y <= 50 else { return false }
        guard point.z >= -50 else { return false }
        guard point.z <= 50 else { return false }
        
        return true
    }
    
    override func part1() -> String {
        return ""
       
        let instructions = input.lines.map { line -> LineData in
            let parts = line.raw.components(separatedBy: .whitespaces)
            let onOff = parts.first! == "on" ? 1 : 0
            let raw2 = parts.last!.replacingOccurrences(of: "x=", with: "").replacingOccurrences(of: "y=", with: "").replacingOccurrences(of: "z=", with: "")
            let second = raw2.components(separatedBy: ",")
            let xMin = Int(second[0].components(separatedBy: "..").first!)!
            let xMax = Int(second[0].components(separatedBy: "..").last!)!
            let yMin = Int(second[1].components(separatedBy: "..").first!)!
            let yMax = Int(second[1].components(separatedBy: "..").last!)!
            let zMin = Int(second[2].components(separatedBy: "..").first!)!
            let zMax = Int(second[2].components(separatedBy: "..").last!)!
            
            return LineData(xMin: xMin, xMax: xMax, yMin: yMin, yMax: yMax, zMin: zMin, zMax: zMax, offOn: onOff)
        }
        var copiedPoints = [Point3: Int]()
        let updated = instructions.dropLast(2)
        for instruction in updated {
            var points = [Point3]()
            
            for x in instruction.xMin...instruction.xMax {
                for y in instruction.yMin...instruction.yMax {
                    for z in instruction.zMin...instruction.zMax {
                        let point = Point3(x: x, y: y, z: z)
                        copiedPoints.updateValue(instruction.offOn, forKey: point)
                    }
                }
            }
        }
        let values = copiedPoints.values.filter{ $0 == 1 }.count
        let keys = copiedPoints.keys.filter{ $0.x > 50 }
        
        return String(values)
    }
    
    override func part2() -> String {
        
        let lineDataList = input.lines.map { line -> LineData in
            let parts = line.raw.components(separatedBy: .whitespaces)
            let onOff = parts.first! == "on" ? 1 : 0
            let raw2 = parts.last!.replacingOccurrences(of: "x=", with: "").replacingOccurrences(of: "y=", with: "").replacingOccurrences(of: "z=", with: "")
            let second = raw2.components(separatedBy: ",")
            let xMin = Int(second[0].components(separatedBy: "..").first!)!
            let xMax = Int(second[0].components(separatedBy: "..").last!)!
            let yMin = Int(second[1].components(separatedBy: "..").first!)!
            let yMax = Int(second[1].components(separatedBy: "..").last!)!
            let zMin = Int(second[2].components(separatedBy: "..").first!)!
            let zMax = Int(second[2].components(separatedBy: "..").last!)!
            
            return LineData(xMin: xMin, xMax: xMax, yMin: yMin, yMax: yMax, zMin: zMin, zMax: zMax, offOn: onOff)
        }
        
        var lightsOn = LightsOn(points: [])
        for lineData in lineDataList {
            var lineDataCopy = lineData
            if lineData.offOn == 1 {
                let addLightsOn = LightsOn(points: lineDataCopy.points)
                lightsOn = lightsOn.adding(addLightsOn)
            } else {
                let subtractingLightsOn = LightsOn(points: lineDataCopy.points)
                lightsOn = lightsOn.subtracting(subtractingLightsOn)
            }
        }
        
        let count = lightsOn.points.underestimatedCount
        
        
        return String(count)
    }
    
}
