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
                LazyVGrid(columns: Array(repeating: GridItem(), count: game.gameSize.width())) {
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
                            }

                            if block.state == .flagged {
                                game.fields[block.fieldID].state = .hidden
                            }

                        } label: {
                            Text(" ")
                        }
                        .glassEffect(in: .rect(cornerRadius: 16.0))
                        .onLongPressGesture {
                            game.fields[block.fieldID].state = .flagged
                        }

                    }
                }
            }

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
