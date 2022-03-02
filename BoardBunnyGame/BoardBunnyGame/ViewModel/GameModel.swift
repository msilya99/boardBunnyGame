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

    @Published var topic: WordCategory = .random
    @Published var numberOfPlayers: Int = 4
    @Published var players: [SinglePlayer] = []

    // MARK: - actions

    // TODO: - refactor this
    private func getPlayers() -> [SinglePlayer] {
        var players: [SinglePlayer] = []
        var words = Array(repeating: getWordForTopic(), count: numberOfPlayers - 1)
        words.append("Ты заяц!")
        words.shuffle()

        for id in 0..<numberOfPlayers {
            players.append(SinglePlayer(id: id, word: words[id]))
        }
        return players
    }

    private func getWordForTopic() -> String {
        guard let word = self.topic.getWordsByTopic().randomElement() else { return "" }
        return word
    }

    func startGame() {
        self.players = getPlayers()
    }
}
