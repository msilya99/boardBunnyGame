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
    @State private var isEditing: Bool = false

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
        .navigationTitle("Изменить имена")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isEditing.toggle()
                } label: {
                    Image(systemName: isEditing ? "checkmark.circle" : "pencil.circle")
                }
                .foregroundColor(themeColorType: .base)
            }
        }
        .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
        .animation(.spring(), value: (self.isEditing))
    }

    func delete(at offsets: IndexSet) {
        gameModel.playerNamesModels.remove(atOffsets: offsets)
        gameModel.numberOfPlayers -= 1
    }

    func move(from source: IndexSet, to destination: Int) {
        gameModel.playerNamesModels.move(fromOffsets: source, toOffset: destination)
    }

    @ViewBuilder
    func deletableView() -> some View {
        let view = ForEach($gameModel.playerNamesModels, id: \.id) { player in
            TextField("Введите имя", text: player.name) { editingChanged in
                guard !editingChanged, player.name.wrappedValue.isEmpty else { return }
                player.name.wrappedValue = gameModel.getDefaultName(id: player.id.wrappedValue)
            }
        }.onMove(perform: move)

        if gameModel.numberOfPlayers > 3 {
            view.onDelete(perform: delete)
        } else {
            view
        }
    }
}
