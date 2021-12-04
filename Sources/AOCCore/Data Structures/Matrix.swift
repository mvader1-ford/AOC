//
//  Matrix.swift
//  test
//
//  Created by Dave DeLong on 12/20/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

public enum Bit {
    case on
    case off
    
    public func toggled() -> Bit {
        if self == .on { return .off }
        return .on
    }
}

public class Matrix<T: Hashable>: Hashable, CustomStringConvertible {
    
   public func column(_ index: Int) -> [T] {
        var column = [T]()
        for item in 0..<5 {
            column.append(self[item, index])
        }
        return column
    }
    
//    public func row(_ index: Int) -> [T] {
//         var column = [T]()
//         for item in 0..<5 {
//             column.append(self[index, item])
//         }
//         return column
//     }
    
    public static func ==(lhs: Matrix, rhs: Matrix) -> Bool {
        guard lhs.data.count == rhs.data.count else { return false }
        let rows = zip(lhs.data, rhs.data)
        let rowsEqual = rows.map { $0 == $1 }
        return rowsEqual.reduce(true) { $0 && $1 }
    }
    
    public private(set) var data: Array<Array<T>>
    
    public var rowCount: Int { return data.count }
    public var colCount: Int { return data.first?.count ?? 0 }
    
    public var positions: AnySequence<Position> {
        let maxY = rowCount
        let maxX = colCount
        let s = sequence(state: (x: -1, y: 0)) { s -> Position? in
            if s.x < maxX-1 {
                s.x += 1
            } else {
                s.x = 0
                s.y += 1
            }
            if s.y < maxY {
                return Position(x: s.x, y: s.y)
            } else {
                return nil
            }
        }
        return AnySequence(s)
    }
    
    public func copy() -> Matrix<T> {
        return Matrix(data)
    }
    
    public func row(_ r: Int) -> Array<T> {
        return data[r]
    }
    
    public var description: String {
        return "[" + data.map({ row -> String in
            "[" + row.map { String(describing: $0) }.joined(separator: " ") + "]"
        }).joined(separator: "\n ") + "]"
    }
    
    public init(_ initial: [[T]]) {
        data = initial
    }
    
    public init(rows: Int, columns: Int, value: T) {
        data = (0..<rows).map { r -> Array<T> in
            return Array(repeating: value, count: columns)
        }
    }
    
    public init(recombining: Matrix<Matrix<T>>) {
        data = []
        for r in 0 ..< recombining.rowCount {
            let first = recombining.get(r, col: 0)
            var rows = Array(repeating: Array<T>(), count: first.rowCount)
            
            for c in 0 ..< recombining.colCount {
                let subMatrix = recombining.get(r, col: c)
                
                for subR in 0 ..< subMatrix.rowCount {
                    rows[subR].append(contentsOf: subMatrix.row(subR))
                }
                
            }
            
            data.append(contentsOf: rows)
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(data)
    }
    
    public func count(where matches: (T) -> Bool) -> Int {
        return data.reduce(0) { (soFar, row) -> Int in
            return soFar + row.count(where: matches)
        }
    }
    
    public func map<New>(_ block: (_ row: Int, _ col: Int, _ value: T) -> New) -> Matrix<New> {
        var newData = Array<Array<New>>()
        
        for (rowIndex, row) in data.enumerated() {
            var newRow = Array<New>()
            for (colIndex, value) in row.enumerated() {
                let newValue = block(rowIndex, colIndex, value)
                newRow.append(newValue)
            }
            newData.append(newRow)
        }
        
        return Matrix<New>(newData)
    }
    
    public subscript(_ row: Int, _ col: Int) -> T {
        get { return data[row][col] }
        set { data[row][col] = newValue }
    }
    
    public subscript(_ coordinate: Position) -> T {
        get { return data[coordinate.row][coordinate.col] }
        set { data[coordinate.row][coordinate.col] = newValue }
    }
    
    public func has(_ coordinate: Position) -> Bool {
        return coordinate.row >= 0 && coordinate.row < rowCount && coordinate.col >= 0 && coordinate.col < colCount
    }
    
    public func at(_ position: Position) -> T? {
        return data.at(position.row)?.at(position.col)
    }
    
    public func get(_ row: Int, col: Int) -> T {
        return data[row][col]
    }
    
    public func set(_ row: Int, col: Int, _ val: T) {
        data[row][col] = val
    }
    
    public func first(from position: Position, along vector: Vector2, where matches: (T) -> Bool) -> T? {
        var p = position + vector
        while has(p) {
            if matches(self[p]) { return self[p] }
            p += vector
        }
        return nil
    }
    
    public func rotateCW() -> Matrix<T> {
        let newRowCount = data[0].count
        let newColCount = data.count
        let newData = (0 ..< newRowCount).map { row in
            return (0 ..< newColCount).map { data[newColCount - $0 - 1][row] }
        }
        return Matrix(newData)
    }
    
    public func rotate(_ clockwiseTurns: Int) -> Matrix<T> {
        let turns = clockwiseTurns % 4
        if turns == 0 { return Matrix(data) }
        
        var current = data
        for _ in 0 ..< turns {
            var thisTurn = Array<Array<T>>()
            for i in 0 ..< current[0].count {
                var newRow = Array<T>()
                for row in current.reversed() {
                    newRow.append(row[i])
                }
                thisTurn.append(newRow)
            }
            current = thisTurn
        }
        return Matrix(current)
    }
    
    public func flip() -> Matrix<T> {
        var flipped = Array<Array<T>>()
        for row in data.reversed() {
            flipped.append(row)
        }
        return Matrix(flipped)
    }
    
    public func mirror() {
        data = data.map { $0.reversed() }
    }
    
    public func subdivide() -> Matrix<Matrix<T>> {
        let size = data[0].count
        
        let jump = (size % 2 == 0) ? 2 : 3
        
        let jumpCount = size / jump
        
        var newData = Array<Array<Matrix<T>>>()
        
        for r in 0 ..< jumpCount {
            var newRow = Array<Matrix<T>>()
            
            for c in 0 ..< jumpCount {
                let row = (r * jump)
                let col = (c * jump)
                
                var rows = Array<Array<T>>()
                for ri in 0 ..< jump {
                    let thisRow = data[row + ri]
                    let slice = Array(thisRow[col ..< col + jump])
                    rows.append(slice)
                }
                newRow.append(Matrix(rows))
            }
            
            newData.append(newRow)
        }
        
        return Matrix<Matrix<T>>(newData)
    }
    
    public func inset(by insets: Dictionary<Heading, Int>) {
        var newData = data
        if let dropTop = insets[.top] {
            newData.removeFirst(dropTop)
        }
        if let dropBottom = insets[.bottom] {
            newData.removeLast(dropBottom)
        }
        if let dropLeft = insets[.left] {
            newData = newData.map { Array($0.dropFirst(dropLeft)) }
        }
        if let dropRight = insets[.right] {
            newData = newData.map { Array($0.dropLast(dropRight)) }
        }
        data = newData
    }
    
    public func withSlidingWindow(of size: Size, perform: (Array<Array<T>>) -> Void) {
        let xTranslations = data[0].count - size.width
        let yTranslations = data.count - size.height
        
        guard xTranslations > 0 else { return }
        guard yTranslations > 0 else { return }
        
        for yOffset in (0 ..< yTranslations) {
            for xOffset in (0 ..< xTranslations) {
                var window = Array<Array<T>>()
                for h in (0 ..< size.height) {
                    let row = data[yOffset + h]
                    window.append(Array(row[xOffset ..< (xOffset + size.width)]))
                }
                perform(window)
            }
        }
        
    }
}

