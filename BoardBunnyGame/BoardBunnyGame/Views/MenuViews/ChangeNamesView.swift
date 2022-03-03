//
//  ChangeNamesView.swift
//  Zaec
//
//  Created by Ilya Maslau on 3.03.22.
//

import SwiftUI

struct ChangeNamesView: View {

    // MARK: - variables

    @ObservedObject var gameModel: GameModel

    // MARK: - gui

    var body: some View {
        VStack{
            // TODO: - удалить игрока
            List {
                deletableView()
            }

            PrimaryButton(title: "Добавить игрока", action: {
                gameModel.numberOfPlayers += 1
            })
                .hidden(gameModel.numberOfPlayers == 10)
        }
    }

    func delete(at offsets: IndexSet) {
        gameModel.playerNamesModels.remove(atOffsets: offsets)
        gameModel.numberOfPlayers -= 1
    }

    @ViewBuilder
    func deletableView() -> some View {
        let view = ForEach($gameModel.playerNamesModels, id: \.id) { player in
            TextField("", text: player.name)
        }

        if gameModel.numberOfPlayers > 3 {
            view.onDelete(perform: delete)
        } else {
            view
        }
    }
}
