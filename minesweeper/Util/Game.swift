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
        let maxFields = maxX * maxY

        var amountOfBombs: Int {
            let fields: Double = Double(maxFields - 1)
            let bombs = Int.random(in: 0...Int((floor(fields))))
            return bombs
        }

        fields = []
        // Initialize all fields as empty
        for i in 0..<(maxFields) {
            let x = i % maxX
            let y = i / maxX
            let field = Field(
                fieldID: i,
                type: .empty,
                position: Position(X: x, Y: y)
            )
            fields.append(field)
        }
        // Place bombs
        var bombPlacements = Set<Int>()
        while bombPlacements.count <= amountOfBombs {
            let placement = Int.random(in: 0..<(maxX * maxY))
            bombPlacements.insert(placement)
        }
        for placement in bombPlacements {
            fields[placement].type = .bomb
        }
        // Assign numbers to fields adjacent to bombs
        let neighborOffsets = [
            (-1, -1), (0, -1), (1, -1),
            (-1,  0),         (1,  0),
            (-1,  1), (0,  1), (1,  1)
        ]
        for i in 0..<fields.count {
            guard fields[i].type != .bomb else { continue }
            let x = fields[i].position.X
            let y = fields[i].position.Y
            var bombCount = 0
            for (dx, dy) in neighborOffsets {
                let nx = x + dx
                let ny = y + dy
                if nx >= 0 && nx < maxX && ny >= 0 && ny < maxY {
                    let neighborIndex = ny * maxX + nx
                    if fields[neighborIndex].type == .bomb {
                        bombCount += 1
                    }
                }
            }
            if bombCount > 0 {
                fields[i].type = .numbered(bombCount)
            }
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
