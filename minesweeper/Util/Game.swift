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

        for i in 0..<(maxFields) {

            let x = i % maxY
            let y = i / maxX

            let field = Field(
                fieldID: i,
                type: .empty,
                position: Position(X: x, Y: y)
            )

            fields.append(field)
        }

        for _ in 0...amountOfBombs {
            let placement = Int.random(in: 0..<(maxX * maxY))

            fields[placement].type = .bomb
        }

        // ai made this im dead inside ok
        for i in 0..<maxFields {
            if fields[i].type == .bomb {
                let bombX = fields[i].position.X
                let bombY = fields[i].position.Y

                for xOffset in -1...1 {
                    for yOffset in -1...1 {
                        if xOffset == 0 && yOffset == 0 { continue }

                        let neighborX = bombX + xOffset
                        let neighborY = bombY + yOffset

                        if neighborX >= 0 && neighborX < maxX && neighborY >= 0
                            && neighborY < maxY
                        {

                            let neighborIndex = neighborY * maxX + neighborX

                            if fields[neighborIndex].type == .empty {
                                fields[neighborIndex].type = .numbered(1)
                            } else if case .numbered(let count) = fields[
                                neighborIndex
                            ].type {
                                fields[neighborIndex].type = .numbered(
                                    count + 1
                                )
                            }
                        }
                    }
                }
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
