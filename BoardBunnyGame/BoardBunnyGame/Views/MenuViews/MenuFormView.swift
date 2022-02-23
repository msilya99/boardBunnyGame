//
//  MenuFormView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI

struct MenuFormView: View {

    private let topics = ["Случайная", "Архитектура", "Музыка", "Кино и сериалы"]
    @Binding var selectedTopic: String
    @Binding var numbersOfPlayers: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Тема:")
                    .foregroundColor(themeColorType: .baseInverted)
                Spacer()
                // FIXME: - fix color 
                Picker("Тема:", selection: $selectedTopic) {
                    ForEach(topics, id: \.self) {
                        Text($0)
                    }
                }
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
}
