//
//  GamePreviewView.swift
//  minesweeper
//
//  Created by Patryk Puciłowski on 11/07/2025.
//

import SwiftUI

struct GamePreviewView: View {

    var game: Game

    func makeNormalDate(_ date: Date) -> String {
        let relativeDate = RelativeDateTimeFormatter()
        relativeDate.unitsStyle = .full

        let convertedDate = relativeDate.localizedString(
            for: date,
            relativeTo: Date.now
        )

        return convertedDate
    }

    var body: some View {
        VStack {

            HStack {
                Text(
                    makeNormalDate(game.creationDate)
                )

                Spacer()

                switch game.gameState {
                case .ongoing:
                    Text("Outoging")
                case .won:
                    Label("Won", systemImage: "trophy.fill")
                        .foregroundStyle(.yellow)
                case .lost:
                    Label("Lost", systemImage: "xmark")
                        .foregroundStyle(.red)
                }
            }

            HStack {
                if game.gameState == .ongoing {
                    Label(
                        "\(game.getShownBlocks())/\(game.gameSize.AmountOfFields(source: game.gameSize.rawValue))",
                        systemImage: "square"
                    )

                    Spacer()

                    Label(
                        "\(game.getFlags())",
                        systemImage: "flag.fill"
                    )
                } else {
                    Label(
                        "\(game.getCompletedBlocks())/\(game.gameSize.AmountOfFields(source: game.gameSize.rawValue))",
                        systemImage: "square"
                    )

                    Spacer()

                    Label(
                        "\(game.getShownFlags())",
                        systemImage: "flag.fill"
                    )
                }
            }

        }
        .bold()
        .font(.title3)
        .fontDesign(.rounded)
    }
}

#Preview {
    GamePreviewView(game: Game(gameSize: .small))
}
