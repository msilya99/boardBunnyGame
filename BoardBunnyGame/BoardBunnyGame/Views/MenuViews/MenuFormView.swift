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
                          options: WordCategory.allCases,
                          optionToString: { $0.getTopicTitle() },
                          selected: $gameModel.topics)
            Stepper("Игроков: \(gameModel.numberOfPlayers)",
                    value: $gameModel.numberOfPlayers, in: 3...10)
                .colorInvert()
            Toggle("Использовать имена",
                   isOn: $isToogleOn)
                .onChange(of: isToogleOn) { isOn in
                    gameModel.isUsingCustomNames = isOn
                }
                .foregroundColor(themeColorType: .baseInverted)
                .tint(Color.init(#colorLiteral(red: 0.8901987672, green: 0.7450953126, blue: 0.8039216399, alpha: 1)))
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
