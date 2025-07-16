//
//  Game.swift
//  minesweeper
//
//  Created by Patryk Puciłowski on 10/07/2025.
//

import Foundation
import SwiftData

@Model
class Game {

    var gameID: UUID = UUID()

    var creationDate: Date = Date.now

    var gameSize: MapSize

    var gameState: gameState

    var score: Int

    var fields: [Field] = []

    var fieldsMarked: [Field] = []

    init(gameSize: MapSize, ) {
        self.gameID = UUID()
        self.gameSize = gameSize
        self.gameState = .ongoing
        self.fields = []
        self.fieldsMarked = []
        self.score = 0

        startGame()
    }

    func startGame() {
        let maxX = self.gameSize.width()
        let maxY = self.gameSize.height()

        for i in 0..<(maxX * maxY) {

            let x = i % maxY
            let y = i / maxX

            let field = Field(
                fieldID: i,
                type: .random(),
                position: Position(X: x, Y: y)
            )

            fields.append(field)
        }
    }

    func winGame() {
        for i in self.fields.indices {
            if fields[i].state == .visible || fields[i].state == .flagged {
                fieldsMarked.append(fields[i])
            }
        }
        self.gameState = .won
    }

    func loseGame() {
        for i in self.fields.indices {
            if fields[i].state == .visible || fields[i].state == .flagged {
                fieldsMarked.append(fields[i])
            }
        }
        self.gameState = .lost
    }

    func getFlags() -> Int {
        var amountOfFlags: Int = 0

        for i in 0..<self.gameSize.AmountOfFields(source: gameSize.rawValue) {
            if self.fields[i].state == .flagged {
                amountOfFlags += 1
            }
        }

        return amountOfFlags
    }

    func getShownBlocks() -> Int {
        var amountofBlocksVisible: Int = 0

        for i in 0..<self.gameSize.AmountOfFields(source: gameSize.rawValue) {
            if self.fields[i].state == .visible {
                amountofBlocksVisible += 1
            }
        }
        return amountofBlocksVisible
    }

    func getCompletedBlocks() -> Int {
        var amountofBlocksVisible: Int = 0

        for field in self.fieldsMarked {
            if field.state == .visible {
                amountofBlocksVisible += 1
            }
        }
        return amountofBlocksVisible
    }

    func getShownFlags() -> Int {
        var amountofBlocksVisible: Int = 0

        for field in self.fieldsMarked {
            if field.state == .flagged {
                amountofBlocksVisible += 1
            }
        }
        return amountofBlocksVisible
    }

    
    // TODO: TURN THIS INTO ONE FUNCTION WITH AN ENUM OR BOOL OR SMTHNG
}

public enum gameState: Codable {
    case ongoing
    case won
    case lost
}
