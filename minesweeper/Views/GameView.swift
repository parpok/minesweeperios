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

            HStack {
                Spacer()
                Text(game.gameSize.rawValue)

            }
            .padding()

            Text(game.score.description)
                .bold()
                .font(.title)

        }
        .onAppear {
            modelContext.insert(game)
        }
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

}

#Preview {
    GameView(game: Game(gameSize: .small))
}
