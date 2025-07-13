//
//  MapSize.swift
//  minesweeper
//
//  Created by Patryk Puciłowski on 14/07/2025.
//
import Foundation

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
