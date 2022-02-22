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
                MenuFormView(selectedTopic: $gameModel.topic,
                             numbersOfPlayers: $gameModel.numbersOfPlayers)
                Spacer()
                PrimaryButton(title: "Начать игру") {
                    isActive = true
                }

                NavigationLink(destination: SelectedTopicView(),
                               isActive: $isActive) { }
            }
            .navigationTitle("Configure the game")
        }.environmentObject(gameModel)
    }
}
