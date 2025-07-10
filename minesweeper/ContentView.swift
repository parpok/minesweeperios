//
//  ContentView.swift
//  minesweeper
//
//  Created by Patryk Puciłowski on 10/07/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {

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
                        Text("GAME")
                    } label: {
                        Label("Start game", systemImage: "gamecontroller")
                    }

                }

                Section("Past games") {
                    ForEach(games) { _ in
                        Text("GAME")
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
