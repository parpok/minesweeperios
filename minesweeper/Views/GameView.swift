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

                            game.fields[block.fieldID].state = .visible

                            if block.type.numer != 0 {
                                game.score += block.type.numer
                            }

                            if block.type == .bomb {
                                game.loseGame()

                                for i in game.fields.indices {
                                    if game.fields[i].state != .flagged {
                                        game.fields[i].state = .visible
                                    }
                                }
                            }

                            if block.state == .flagged {
                                game.fields[block.fieldID].state = .hidden
                                game.score = game.score - block.type.numer
                            }

                            do {
                                try modelContext.save()
                            } catch {
                                print(error.localizedDescription)
                            }

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
                                    if block.state == .hidden {
                                        game.fields[block.fieldID].state =
                                            .flagged
                                    } else if block.state == .flagged {
                                        game.fields[block.fieldID].state =
                                            .hidden
                                    }
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
