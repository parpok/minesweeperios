//
//  minesweeperApp.swift
//  minesweeper
//
//  Created by Patryk Puciłowski on 10/07/2025.
//

import SwiftData
import SwiftUI

@main
struct minesweeperApp: App {
    //    @Environment(\.modelContext) private var modelContext
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Game.self)
    }
}
