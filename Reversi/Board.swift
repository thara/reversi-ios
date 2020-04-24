//
//  Board.swift
//  Reversi
//
//  Created by thara on 2020/04/25.
//  Copyright © 2020 Yuta Koshizawa. All rights reserved.
//

import Foundation

class Board {
    /// 盤の幅（ `8` ）を表します。
    public let width: Int = 8
    
    /// 盤の高さ（ `8` ）を返します。
    public let height: Int = 8
    
    /// 盤のセルの `x` の範囲（ `0 ..< 8` ）を返します。
    public let xRange: Range<Int>
    
    /// 盤のセルの `y` の範囲（ `0 ..< 8` ）を返します。
    public let yRange: Range<Int>
    
    private var cells: [Disk?]
    
    public init() {
        xRange = 0 ..< width
        yRange = 0 ..< height
        cells = Array(repeating: nil, count: width * height)
    }
    
    public func diskAt(x: Int, y: Int) -> Disk? {
        guard xRange.contains(x) && yRange.contains(y) else { return nil }
        return cells[y * width + x]
    }
    
    public func setDisk(_ disk: Disk?, atX x: Int, y: Int) {
        guard xRange.contains(x) && yRange.contains(y) else { return }
        cells[y * width + x] = disk
    }
}
