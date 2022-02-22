//
//  GameModel.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import Combine

class GameModel: ObservableObject {
    @Published var topic: String = "Случайная"
    @Published var numbersOfPlayers: Int = 4

    // MARK: - actions

    func getWords() -> [String] {
        var words = Array(repeating: getWordForTopic(), count: numbersOfPlayers - 1)
        words.append("Ты заяц!")
        return words.shuffled()
    }

    private func getWordForTopic() -> String {
        return "Рандомное слово"
    }
}
