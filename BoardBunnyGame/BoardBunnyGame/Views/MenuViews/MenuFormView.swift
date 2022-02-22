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
        Form {
            Section() {
                Picker("Тема:", selection: $selectedTopic) {
                    ForEach(topics, id: \.self) {
                        Text($0)
                    }
                }
                Stepper("Игроков: \(numbersOfPlayers)",
                        value: $numbersOfPlayers, in: 3...10)
            }
        }
    }
}
