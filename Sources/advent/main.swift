//
//  File.swift
//  
//
//  Created by Dave DeLong on 9/24/19.
//

import AOC2021

let d = Day.day(for: Date())

let d1 = Date()
let (p1, p2) = d.run()
let d2 = Date()
print("Executing \(type(of: d))")
print("Part 1: \(p1)")
print("Part 2: \(p2)")
print("Time: \(d2.timeIntervalSince(d1))")
