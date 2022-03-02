//
//  CardContentView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI

struct CardContentView: View {

    // MARK: - variables

    @ObservedObject var gameModel: GameModel

    // MARK: - gui

    var body: some View {
        VStack {
            GeometryReader { geometry in
                TopPurpleView(size: geometry.size)
                VStack(spacing: 24) {
                    DateView(text: $gameModel.selectedTopicTitle)
                    if gameModel.players.isEmpty {
                        Spacer()
                        Text("Начать игру")
                            .onTapGesture(perform: {
                                gameModel.startGame(isRestarting: false)
                            })
                            .font(.largeTitle)
                    }
                    ZStack(alignment: .center) {
                        ForEach(gameModel.players.reversed(), id: \.self) { player in
                            Group {
                                // Range Operator
                                if 0...gameModel.numberOfPlayers - 1 ~= player.id {
                                    CardView(player: player, onRemove: { removedPlayer in
                                        // Remove that user from our array
                                        gameModel.players.removeAll { $0.id == removedPlayer.id }
                                    })
                                        .disabled(player.id != gameModel.players.first?.id)
                                        .frame(width: geometry.size.width,
                                               height: geometry.size.height * 0.85)
                                }
                            }
                            .hidden(player.id != gameModel.players.first?.id)
                        }
                    }
                    Spacer()
                }
            }
            .navigationBackButton(colorType: .baseInverted)
            .onDisappear{
                self.gameModel.stopGame()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.gameModel.startGame(isRestarting: true)
                    } label: {
                        Image(systemName: "repeat")
                    }
                    .hidden(self.gameModel.players.isEmpty)
                    .foregroundColor(themeColorType: .baseInverted)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .padding()
    }
}
