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

    init(gameSize: MapSize, ) {
        self.gameID = UUID()
        self.gameSize = gameSize
        self.gameState = .ongoing
        self.fields = []
        self.score = 0

        startGame()
    }

    func startGame() {
        let size = self.gameSize.AmountOfFields(source: gameSize.rawValue)

        for i in 0...size {
            let field = Field(fieldID: i, state: .hidden, type: .random())

            fields.append(field)
        }
    }

    func winGame() {
        self.gameState = .won
    }

    func loseGame() {
        self.gameState = .lost
    }

    func getFlags() -> Int {
        var amountOfFlags: Int = 0

        for i in 0...self.gameSize.AmountOfFields(source: gameSize.rawValue) {
            if self.fields[i].state == .flagged {
                amountOfFlags += 1
            }
        }

        return amountOfFlags
    }

    func getShownBlocks() -> Int {
        var amountofBlocksVisible: Int = 0

        for i in 0...self.gameSize.AmountOfFields(source: gameSize.rawValue) {
            if self.fields[i].state == .visible {
                amountofBlocksVisible += 1
            }
        }
        return amountofBlocksVisible
    }

}

public enum gameState: Codable {
    case ongoing
    case won
    case lost
}
