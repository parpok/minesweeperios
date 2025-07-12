//
//  Field.swift
//  minesweeper
//
//  Created by Patryk Puciłowski on 10/07/2025.
//

import Foundation
import SwiftData

public enum MapSize: String, CaseIterable, Codable {

    case small = "9x9"
    case medium = "16x16"

    case large = "30x16"

    var id: String {
        return self.rawValue
    }

    func AmountOfFields(source: MapSize.RawValue) -> Int {
        let numbers = source.components(separatedBy: "x")
        if let first = Int(numbers.first ?? "0"),
            let second = Int(numbers.last ?? "0")
        {
            return first * second
        } else {
            return 0
        }
    }
    
    func width() -> Int {
        let numbers = self.rawValue.components(separatedBy: "x")
        if let first = Int(numbers.first ?? "0") {
            return first
        } else {
            return 0
        }
    }
    
    func height() -> Int {
        let numbers = self.rawValue.components(separatedBy: "x")
        if let second = Int(numbers.last ?? "0") {
            return second
        } else {
            return 0
        }
    }
}

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

        static func random() -> BlockType {
            let randomChoice = Int.random(in: 0...2)

            switch randomChoice {
            case 0:
                return .numbered(Int.random(in: 1...4))
            case 1:
                return .bomb
            default:
                return .empty
            }
        }
    }

    let fieldID: Int

    var state: fieldState

    var type: BlockType
    
    var position: [Int:Int]

    init(fieldID: Int, type: BlockType, position: [Int : Int]) {
        self.fieldID = fieldID
        self.state = .hidden
        self.type = type
        self.position = position
    }

}
