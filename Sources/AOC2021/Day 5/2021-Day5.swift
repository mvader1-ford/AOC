//
//  Day5.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import CoreGraphics

extension CGPoint: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
    
    
}

class Day5: Day {
    
    class SubLine {

        let start: CGPoint
        let end: CGPoint

        init(terminals: [String]) {
            let start = terminals.first!
            let end = terminals.last!
            let s = start.components(separatedBy: ",")
            let e = end.components(separatedBy: ",")
            self.start = CGPoint(x: Int(s[0])!, y: Int(s[1])!)
            self.end = CGPoint(x: Int(e[0])!, y: Int(e[1])!)
        }
        
        var maxYFound: Int = 0
        
        var maxXFound: Int = 0

        lazy var data: [CGPoint] = {
            var points = [CGPoint]()
            var minX = Int(min(start.x, end.x))
            var minY = Int(min(start.y, end.y))
            var maxX = Int(max(start.x, end.x))
            var maxY = Int(max(start.y, end.y))
            maxXFound = maxX
            maxYFound = maxY
            
            if abs(start.x - end.x) == abs(start.y - end.y) {
                let slope = (end.y - start.y) / (end.x - start.x)
                let b = start.y - slope * start.x
                for x in minX...maxX {
                    let y = slope * CGFloat(x) + b
                    let pointFound = CGPoint(x: CGFloat(x), y: CGFloat(y))
                    points.append(pointFound)
                }
            } else {
                for x in minX...maxX {
                    for y in minY...maxY {
                        points.append(CGPoint(x: x, y: y))
                    }
                }
            }
            
            return points
        }()
        
        lazy var isDiagonal: Bool = {
            return abs(start.y - end.y) == abs(start.x - end.x)
        }()
        
        lazy var isHorizontal: Bool = {
            return start.y == end.y
        }()
        
        lazy var isVertical: Bool = {
            return start.x == end.x
        }()
        
        lazy var horizontalPoints: [CGFloat]? = {
            guard isHorizontal else { return nil }
            
            return data.map{ $0.x }
        }()
        
        lazy var verticalPoints: [CGFloat]? = {
            guard isVertical else { return nil }
            
            return data.map{ $0.y }
        }()
        
        lazy var dataSet: Set<CGPoint> = {
            return Set(data)
        }()
        
    }
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    lazy var sharedSublines: [SubLine] = {
        let lines = input.lines.raw
        let coords = lines.map{ $0.components(separatedBy: "->").map{ $0.trimmed()} }
        
        return coords.map{ SubLine(terminals: $0) }
    }()
    
    lazy var horizontalVerticalDiagonalLines: [SubLine] = {
        return sharedSublines.filter{ $0.isHorizontal || $0.isVertical || $0.isDiagonal }
    }()
    
    lazy var horizontalVerticalLines: [SubLine] = {
        return horizontalVerticalDiagonalLines.filter{ !$0.isDiagonal }
    }()

    override func part1() -> String {
        let horizontalAndVerticalLines = horizontalVerticalLines
        let dataFound = horizontalAndVerticalLines.map{ $0.data }.flatMap{ $0 }
        var pointCounter = [CGPoint: Int]()
        for point in dataFound {
            let count = horizontalAndVerticalLines.filter{ $0.dataSet.contains(point) }.count
            pointCounter.updateValue(count, forKey: point)
        }
        
        let twoOrMore = pointCounter.filter{ $0.value > 1 }
        
        return String(twoOrMore.keys.count)
    }
    
    override func part2() -> String {
        let horizontalAndVerticalLines = horizontalVerticalDiagonalLines
        let dataFound = horizontalAndVerticalLines.map{ $0.data }.flatMap{ $0 }
        var pointCounter = [CGPoint: Int]()
        for point in dataFound {
            let count = horizontalAndVerticalLines.filter{ $0.dataSet.contains(point) }.count
            pointCounter.updateValue(count, forKey: point)
        }
        
        let twoOrMore = pointCounter.filter{ $0.value > 1 }
        
        return String(twoOrMore.keys.count)
    }
    
}
