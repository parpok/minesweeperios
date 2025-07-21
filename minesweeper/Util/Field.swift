//
//  Field.swift
//  minesweeper
//
//  Created by Patryk Puciłowski on 10/07/2025.
//

import Foundation
import SwiftData

struct Field: Codable, Hashable {

    enum fieldState: Codable {
        case hidden,
            visible,
            flagged
    }

    enum BlockType: Equatable, Codable, Hashable {

        case numbered(Int)
        case bomb
        case empty

        var numer: Int {
            if case .numbered(let int) = self {
                return int
            }
            return 0
        }
    }

    let fieldID: Int

    var state: fieldState

    var type: BlockType

    var position: Position

    init(fieldID: Int, type: BlockType, position: Position) {
        self.fieldID = fieldID
        self.state = .hidden
        self.type = type
        self.position = position
    }

}

struct Position: Codable, Hashable {
    var X: Int
    var Y: Int

    init(X: Int, Y: Int) {
        self.X = X
        self.Y = Y
    }
}
