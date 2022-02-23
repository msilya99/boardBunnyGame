//
//  GameModel.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import Combine

struct SinglePlayer: Hashable {
    var id: Int
    var word: String
}

class GameModel: ObservableObject {
    @Published var topic: String = "Случайная"
    @Published var numbersOfPlayers: Int = 4

    // MARK: - actions

    // TODO: - refactor this
    func getPlayers() -> [SinglePlayer] {
        var players: [SinglePlayer] = []
        var words = Array(repeating: getWordForTopic(), count: numbersOfPlayers - 1)
        words.append("Ты заяц!")
        words.shuffle()

        for id in 0..<numbersOfPlayers {
            players.append(SinglePlayer(id: id, word: words[id]))
        }
        return players
    }

    private func getWordForTopic() -> String {
        return "Рандомное слово"
    }
}
