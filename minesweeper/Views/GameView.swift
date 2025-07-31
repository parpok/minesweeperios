//
//  GameView.swift
//  minesweeper
//
//  Created by Patryk Puciłowski on 11/07/2025.
//

import SwiftData
import SwiftUI

struct GameView: View {

    var game: Game

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {

            VStack {
                HStack {
                    Spacer()
                    Text(game.gameSize.rawValue)

                }
                .padding()

                Text(game.score.description)
                    .bold()
                    .font(.title)
            }

            GeometryReader { geometry in
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(),
                        count: game.gameSize.width()
                    )
                ) {
                    ForEach(
                        game.fields,
                        id: \.self
                    ) { block in
                        Button {
                            guard block.state == .hidden else { return }
                            
                            // First click logic (score == 0)
                            if game.score == 0 {
                                // If bomb, swap this cell with a non-bomb
                                if block.type == .bomb {
                                    // Find a non-bomb cell to swap types with
                                    if let safeIndex = game.fields.firstIndex(where: { $0.type != .bomb && $0.fieldID != block.fieldID }) {
                                        game.fields[safeIndex].type = .bomb
                                        game.fields[block.fieldID].type = .empty
                                    }
                                }
                                
                                // Reveal the clicked block and its flood fill neighbors
                                revealFloodFill(from: block.fieldID)
                                
                                // Set the score to nonzero so this logic only runs once
                                game.score = 1
                                saveGame()
                                return
                            }
                            
                            // Subsequent clicks (normal gameplay)
                            if block.type == .bomb {
                                game.loseGame()
                                for i in game.fields.indices {
                                    if game.fields[i].state != .flagged {
                                        game.fields[i].state = .visible
                                    }
                                }
                                saveGame()
                                return
                            }
                            
                            game.fields[block.fieldID].state = .visible
                            if block.type.numer != 0 {
                                game.score += block.type.numer
                            }
                            saveGame()
                        } label: {

                            VStack {
                                VStack {
                                    switch block.state {
                                    case .hidden:
                                        Text(" ")
                                    case .flagged:
                                        Image(systemName: "flag.fill")
                                    case .visible:
                                        switch block.type {
                                        case .bomb:
                                            Text("💣")
                                        case .empty:
                                            Text(" ")
                                        case .numbered(1):
                                            Text("1")
                                        case .numbered(2):
                                            Text("2")
                                        case .numbered(3):
                                            Text("3")
                                        case .numbered(4):
                                            Text("4")
                                        default:
                                            Text(" ")
                                        }
                                    }
                                }
                                .onLongPressGesture {
                                    guard block.state != .visible else { return }
                                    if block.state == .hidden {
                                        game.fields[block.fieldID].state = .flagged
                                    } else if block.state == .flagged {
                                        game.fields[block.fieldID].state = .hidden
                                        if block.type.numer != 0 {
                                            game.score -= block.type.numer
                                        }
                                    }
                                    saveGame()
                                }
                            }

                            //                            .padding()
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle(radius: 8))
                        .glassEffect(in: .rect(cornerRadius: 16.0))

                    }
                }
            }
            .padding()

        }
        .onAppear {
            modelContext.insert(game)
        }
    }

    private func saveGame() {
        do {
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func revealFloodFill(from index: Int) {
        // Prevent revealing flagged or already visible fields
        guard game.fields[index].state == .hidden else { return }
        game.fields[index].state = .visible
        
        // Only flood fill for empty fields
        if game.fields[index].type == .empty {
            let maxX = game.gameSize.width()
            let maxY = game.gameSize.height()
            let x = game.fields[index].position.X
            let y = game.fields[index].position.Y
            let neighborOffsets = [
                (-1, -1), (0, -1), (1, -1),
                (-1,  0),         (1,  0),
                (-1,  1), (0,  1), (1,  1)
            ]
            for (dx, dy) in neighborOffsets {
                let nx = x + dx
                let ny = y + dy
                if nx >= 0 && nx < maxX && ny >= 0 && ny < maxY {
                    let neighborIndex = ny * maxX + nx
                    revealFloodFill(from: neighborIndex)
                }
            }
        }
    }
}

#Preview {
    GameView(game: Game(gameSize: .small))
}

//
//    @ViewBuilder
//    func createGameView(size: MapSize) -> some View {
//        GeometryReader { geometry in
//            let orientation = UIDevice.current.orientation
//            let (rows, columns) = self.mapSize.numberOfRowsAndColumns(
//                size: size.rawValue
//            )
//            let gridItems: [GridItem] = Array(
//                repeating: .init(.flexible()),
//                count: orientation.isPortrait ? columns : rows
//            )
//
//            ScrollView {
//                LazyVGrid(columns: gridItems) {
//                    ForEach(
//                        0..<self.mapSize.AmountOfFields(
//                            source: self.mapSize.rawValue
//                        ),
//                        id: \.self
//                    ) { block in
//                        Text("🟦")
//                            .padding()
//                    }
//                }
//            }
//
//        }
//        .onAppear {
//            NotificationCenter.default.addObserver(
//                forName: UIDevice.orientationDidChangeNotification,
//                object: nil,
//                queue: .main
//            ) { _ in
//                // Force the view to update when orientation changes
//            }
//        }}
