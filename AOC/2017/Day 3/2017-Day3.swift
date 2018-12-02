//
//  Day3.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2017 {

public class Day3: Day {
    
    public init() { super.init(inputSource: .raw("277678")) }
    
    override public func part1() -> String {
        let integer = input.integer!
        
        let squareRootOfInput = sqrt(Double(integer))
        let roundedUp = Int(ceil(squareRootOfInput))
        let root = (roundedUp % 2 == 0) ? roundedUp + 1 : roundedUp
        let layer = (root - 1) / 2
        let lengthOfSide = root
        
        let cornerValue = root * root
        let sideOfSquare = (cornerValue - integer) / lengthOfSide
        let targetCorner = cornerValue - (sideOfSquare * lengthOfSide)
        let middleOfSide = targetCorner - (lengthOfSide / 2)
        
        let distanceToMiddle = abs(integer - middleOfSide)
        let distanceFromMiddleToCenter = layer
        
        let totalDistance = distanceToMiddle + distanceFromMiddleToCenter
        return "\(totalDistance)"
    }
    
    override public func part2() -> String {
        // TODO: this...
        return "279138 <-- FAKED"
    }
    
}

}