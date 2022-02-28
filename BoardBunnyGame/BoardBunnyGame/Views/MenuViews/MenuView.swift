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
                    DateView(text: "Настройки игры")
                        .padding()
                    Image("bunny")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: geometry.size.height / 4)
                    MenuFormView(selectedTopic: $gameModel.topic,
                                 numbersOfPlayers: $gameModel.numberOfPlayers)
                        .frame(minWidth: geometry.size.width)
                    Spacer()
                    PrimaryButton(title: "Начать игру") {
                        isActive = true
                    }

                    NavigationLink(destination: CardContentView(gameModel: gameModel),
                                   isActive: $isActive) { }
                }
            }
            }.navigationBarHidden(true)
        }
        .accentColor(.black)
        .environmentObject(gameModel)
    }
}
