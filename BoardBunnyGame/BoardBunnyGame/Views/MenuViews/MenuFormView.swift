//
//  MenuFormView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI

struct MenuFormView: View {

    // MARK: - variables

    @Binding var selectedTopics: Set<WordCategory>
    @Binding var numbersOfPlayers: Int

    @Environment(\.colorScheme) var colorScheme

    // MARK: - gui

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Stepper("Игроков: \(numbersOfPlayers)",
                    value: $numbersOfPlayers, in: 3...10)
                .colorInvert()

            MultiSelector(label: Text("Тема:"),
                          options: WordCategory.allCases,
                          optionToString: { $0.getTopicTitle() },
                          selected: $selectedTopics)
        }
        .padding(8)
        .backgroundColor(themeColorType: .base)
        .cornerRadius(10)
        .padding()
    }
}
