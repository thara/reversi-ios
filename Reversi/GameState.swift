//
//  GameState.swift
//  Reversi
//
//  Created by thara on 2020/04/24.
//  Copyright © 2020 Yuta Koshizawa. All rights reserved.
//

import Foundation

enum Player: Int {
    case manual = 0
    case computer = 1
}

class GameState {
    /// どちらの色のプレイヤーのターンかを表します。ゲーム終了時は `nil` です。
    var turn: Disk? = .dark
    
    var boardView: BoardView!
    
    /// ゲームの状態を初期化し、新しいゲームを開始します。
    func newGame() {
        boardView.reset()
        turn = .dark
    }
    
    /// ゲームの状態をファイルに書き出し、保存します。
    func saveGame(at path: String, players: [String]) throws {
        var output: String = ""
        output += turn.symbol
        for side in Disk.sides {
            output += players[side.index]
        }
        output += "\n"
        
        for y in boardView.yRange {
            for x in boardView.xRange {
                output += boardView.diskAt(x: x, y: y).symbol
            }
            output += "\n"
        }
        
        do {
            try output.write(toFile: path, atomically: true, encoding: .utf8)
        } catch let error {
            throw FileIOError.read(path: path, cause: error)
        }
    }
    
    /// ゲームの状態をファイルから読み込み、復元します。
    func loadGame(from path: String) throws -> [Player] {
        let input = try String(contentsOfFile: path, encoding: .utf8)
        var lines: ArraySlice<Substring> = input.split(separator: "\n")[...]
        
        guard var line = lines.popFirst() else {
            throw FileIOError.read(path: path, cause: nil)
        }
        
        do { // turn
            guard
                let diskSymbol = line.popFirst(),
                let disk = Optional<Disk>(symbol: diskSymbol.description)
            else {
                throw FileIOError.read(path: path, cause: nil)
            }
            turn = disk
        }

        // players
        var players = [Player?](repeating: nil, count: Disk.sides.count)
        for side in Disk.sides {
            guard
                let playerSymbol = line.popFirst(),
                let playerNumber = Int(playerSymbol.description),
                let player = Player(rawValue: playerNumber)
            else {
                throw FileIOError.read(path: path, cause: nil)
            }
            players[side.index] = player
        }

        do { // board
            guard lines.count == boardView.height else {
                throw FileIOError.read(path: path, cause: nil)
            }
            
            var y = 0
            while let line = lines.popFirst() {
                var x = 0
                for character in line {
                    let disk = Disk?(symbol: "\(character)").flatMap { $0 }
                    boardView.setDisk(disk, atX: x, y: y, animated: false)
                    x += 1
                }
                guard x == boardView.width else {
                    throw FileIOError.read(path: path, cause: nil)
                }
                y += 1
            }
            guard y == boardView.height else {
                throw FileIOError.read(path: path, cause: nil)
            }
        }
        
        return players.compactMap { $0 }
    }
}

enum FileIOError: Error {
    case write(path: String, cause: Error?)
    case read(path: String, cause: Error?)
}
