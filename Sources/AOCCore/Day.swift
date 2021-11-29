//
//  Day.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

fileprivate let yearRegex = Regex(pattern: #"/AOC(\d+)/"#)
fileprivate let dayRegex = Regex(pattern: #".+?Day (\d+).+?\.txt$"#)
fileprivate let classNameRegex = Regex(pattern: #"AOC(\d+).Day(\d+)"#)

open class Day: NSObject {
    
    public static func day(for date: Date) -> Day {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/New_York")!
        let components = calendar.dateComponents([.year, .day], from: Date())
        return day(for: components.year!, day: components.day!)
    }
    
    public static func day(for year: Int, day: Int) -> Day {
        return Year(year).day(day)
    }
    
    private static let inputFiles: Dictionary<Pair<Int>, String> = {
        let root = URL(fileURLWithPath: "\(#file)").deletingLastPathComponent().deletingLastPathComponent()
        let enumerator = FileManager.default.enumerator(at: root, includingPropertiesForKeys: nil)
        
        var files = Dictionary<Pair<Int>, String>()
        
        while let next = enumerator?.nextObject() as? URL {
            guard let year = yearRegex.match(next.path)?.int(1) else { continue }
            var day = 1
            if let realValue  = dayRegex.match(next.path)?.int(1)  {
                day = realValue
            }
            if year == 2021 && day == 1 {
//                files[Pair(year, day)] = next.path
                files[Pair(year, day)] = "/Users/mark/Documents/AOC/Tools/AOC/Sources/AOC2021/Resources/Day1.txt"
            } else {
                files[Pair(year, day)] = next.path
            }

        }
        
        return files
    }()
    
    public let input: Input
    
    public init(rawInput: String) {
        self.input = Input(rawInput)
        super.init()
    }
    
    public override init() {
        let name = String(cString: class_getName(type(of: self)))
        let match = name.match(classNameRegex)
        let year = match.int(1)!
        let day = match.int(2)!
        
        if let onDiskInputFile = Day.inputFiles[Pair(year, day)] {
            self.input = Input(file: onDiskInputFile)
        } else {
            self.input = Input("")
        }
        super.init()
    }
    
    open func run() -> (String, String) {
        return autoreleasepool {
            (part1(), part2())
        }
    }
    open func part1() -> String { fatalError("Implement \(#function)") }
    open func part2() -> String { fatalError("Implement \(#function)") }
}
