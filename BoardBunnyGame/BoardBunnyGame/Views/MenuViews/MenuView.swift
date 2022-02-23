//
//  MenuView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI

struct MenuView: View {

    // MARK: - variables

    @StateObject private var gameModel: GameModel = GameModel()
    @State private var isActive: Bool = false

    // MARK: - views

    var body: some View {
        NavigationView {
            VStack {
            GeometryReader { geometry in
                TopPurpleView(size: geometry.size)
                VStack {
                    Spacer()
                    MenuFormView(selectedTopic: $gameModel.topic,
                                 numbersOfPlayers: $gameModel.numbersOfPlayers)
                        .frame(width: geometry.size.width, height: 150)
                    Spacer()
                    PrimaryButton(title: "Начать игру") {
                        isActive = true
                    }

                    NavigationLink(destination: CardContentView(gameModel: gameModel),
                                   isActive: $isActive) { }
                }
            }
        }.navigationTitle("Configure the game")
        }
        .accentColor(.black)
        .environmentObject(gameModel)
    }
}
