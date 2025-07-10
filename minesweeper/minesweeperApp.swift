//
//  minesweeperApp.swift
//  minesweeper
//
//  Created by Patryk Puciłowski on 10/07/2025.
//

import SwiftUI
import SwiftData

@main
struct minesweeperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Game.self)
    }
}
