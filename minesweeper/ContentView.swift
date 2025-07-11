//
//  ContentView.swift
//  minesweeper
//
//  Created by Patryk Puciłowski on 10/07/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Game.creationDate, order: .reverse) private var games: [Game]

    @State private var boardSize: MapSize = .small

    var body: some View {
        NavigationStack {

            List {

                Section("New game") {

                    Picker("Board size", selection: $boardSize) {
                        ForEach(MapSize.allCases, id: \.self) { options in
                            Text(options.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)

                    NavigationLink {
                        GameView(game: Game(gameSize: boardSize))
                    } label: {
                        Label("Start game", systemImage: "gamecontroller")
                    }

                }

                if !games.isEmpty {
                    Section("Past games") {
                        ForEach(games) { game in
                            NavigationLink {
                                GameView(game: game)
                            } label: {
                                GamePreviewView(game: game)
                            }
                            .swipeActions {
                                Button(
                                    "Delete",
                                    systemImage: "trash",
                                    role: .destructive
                                ) {
                                    modelContext.delete(game)
                                }
                            }
                            #if os(macOS)
                                .contextMenu {
                                    Button(
                                        "Delete",
                                        systemImage: "trash",
                                        role: .destructive
                                    ) {
                                        modelContext.delete(game)
                                    }
                                }
                            #endif
                        }
                    }
                }
            }
            .navigationTitle("Minesweeper")
        }
    }
}

#Preview {
    ContentView()
}
