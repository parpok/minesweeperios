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

    func getItemCount(in group: [Field], matching state: Field.fieldState)
        -> Int
    {
        var itemCount = 0

        for i in 0..<group.count {
            if group[i].state == state {
                itemCount += 1
            }
        }

        return itemCount
    }
}

public enum gameState: Codable {
    case ongoing
    case won
    case lost
}
