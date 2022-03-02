//
//  MenuFormView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI

struct MenuFormView: View {

    // MARK: - variables

    @Binding var selectedTopic: WordCategory
    @Binding var numbersOfPlayers: Int

    @Environment(\.colorScheme) var colorScheme


    // MARK: - gui

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Тема:")
                    .foregroundColor(themeColorType: .baseInverted)
                Spacer()
                getPickerView()
            }
            Stepper("Игроков: \(numbersOfPlayers)",
                    value: $numbersOfPlayers, in: 3...10)
                .colorInvert()
        }
        .padding(8)
        .backgroundColor(themeColorType: .base)
        .cornerRadius(10)
        .padding()
    }

    @ViewBuilder
    func getPickerView() -> some View {
        let view = Picker("Тема:", selection: $selectedTopic) {
            ForEach(WordCategory.allCases, id: \.self) {
                Text($0.getTopicTitle())
            }
        }

        if colorScheme == .dark {
            view
        } else {
            view.colorInvert()
        }
    }
}
