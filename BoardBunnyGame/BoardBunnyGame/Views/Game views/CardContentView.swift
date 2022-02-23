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

    @State private var players: [SinglePlayer]
    private var numberOfPlayers: Int

    // MARK: - initialization

    init(gameModel: GameModel) {
        self.gameModel = gameModel
        self.players = gameModel.getPlayers()
        self.numberOfPlayers = gameModel.numbersOfPlayers
    }

    /// Return the CardViews width for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - id: The ID of the current player
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(players.count - 1 - id) * 10
        return geometry.size.width - offset
    }

    /// Return the CardViews frame offset for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - id: The ID of the current player
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return  CGFloat(players.count - 1 - id) * 10
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                TopPurpleView(size: geometry.size)
                VStack(spacing: 24) {
                    DateView()
                    if self.players.isEmpty {
                        Spacer()
                        Text("Начать заново")
                            .font(.largeTitle)
                    }
                    ZStack(alignment: .center) {
                        ForEach(self.players, id: \.self) { player in
                            Group {
                                // Range Operator
                                if 0...numberOfPlayers - 1 ~= player.id {
                                    CardView(player: player, onRemove: { removedPlayer in
                                        // Remove that user from our array
                                        self.players.removeAll { $0.id == removedPlayer.id }
                                    })
                                        .frame(width: self.getCardWidth(geometry, id: player.id),
                                               height: geometry.size.height * 0.7)
                                        .offset(x: 0, y: self.getCardOffset(geometry, id: player.id))
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }.padding()
    }
}

struct DateView: View {
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Случайная тема")
                        .font(.title)
                        .bold()
                }
                Spacer()
            }.padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
