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
    @State private var currentGame: Game? = nil

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

                    Button {
                        let newGame = Game(gameSize: boardSize)
                        modelContext.insert(newGame)
                        currentGame = newGame
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
            .navigationDestination(item: $currentGame) { game in
                GameView(game: game)
            }
            .onAppear {
                if let ongoingGame = games.first(where: {
                    $0.gameState == .ongoing
                }) {
                    currentGame = ongoingGame
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
