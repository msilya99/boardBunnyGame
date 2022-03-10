//
//  MenuFormView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI

struct MenuFormView: View {

    // MARK: - variables

    @ObservedObject var gameModel: GameModel
    @Environment(\.colorScheme) var colorScheme
    @State var isToogleOn: Bool

    // MARK: - gui

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            MultiSelector(label: Text("Тема:"),
                          options: gameModel.availableCategories,
                          optionToString: { $0.category },
                          selected: $gameModel.selectedCategories)
            Stepper("Игроков: \(gameModel.numberOfPlayers)",
                    value: $gameModel.numberOfPlayers, in: 3...10)
                .colorInvert()
            Toggle("Использовать имена",
                   isOn: $isToogleOn)
                .onChange(of: isToogleOn) { isOn in
                    gameModel.isUsingCustomNames = isOn
                }
                .foregroundColor(themeColorType: .baseInverted)
                .tint(BaseColors.sh.getColorByType(.bunnyPink))
            if gameModel.isUsingCustomNames {
                NavigationLink("Изменить имена \(Image(systemName: "pencil"))",
                               destination: ChangeNamesView(gameModel: gameModel))
                    .foregroundColor(themeColorType: .baseInverted)
            }
        }
        .padding(8)
        .backgroundColor(themeColorType: .base)
        .cornerRadius(10)
        .padding()
    }
}
