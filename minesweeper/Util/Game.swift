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

    var fields: [Field] = []

    init(gameID: UUID, gameSize: MapSize, gameState: gameState, fields: [Field])
    {
        self.gameID = gameID
        self.gameSize = gameSize
        self.gameState = gameState
        self.fields = fields
        
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

}

public enum gameState: Codable {
    case outgoing
    case won
    case lost
}
