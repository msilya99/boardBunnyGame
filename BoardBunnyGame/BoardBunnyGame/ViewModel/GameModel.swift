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

    // MARK: - variables

    @Published var topics: Set<WordCategory> = Set([.random]) {
        didSet {
            self.updateSelectedTopic()
        }
    }

    @Published var numberOfPlayers: Int = 4
    @Published var players: [SinglePlayer] = [] {
        didSet {
            guard players.isEmpty else { return }
            updateSelectedTopic()
        }
    }

    @Published var selectedTopic: WordCategory = .random {
        didSet {
            selectedTopicTitle = selectedTopic.getTopicTitle()
        }
    }

    @Published var selectedTopicTitle: String = WordCategory.random.getTopicTitle()

    // MARK: - actions

    func updateSelectedTopic() {
        guard let topic = topics.randomElement() else { return }
        selectedTopic = topic
    }

    func startGame(isRestarting: Bool) {
        if isRestarting { updateSelectedTopic() }
        self.players = getPlayers()
    }

    func stopGame() {
        self.updateSelectedTopic()
        self.players = []
    }

    private func getPlayers() -> [SinglePlayer] {
        var players: [SinglePlayer] = []
        var words = Array(repeating: getWordForTopic(), count: numberOfPlayers - 1)
        words.append("ЗАЕЦццц!")
        words.shuffle()

        for id in 0..<numberOfPlayers {
            players.append(SinglePlayer(id: id, word: words[id]))
        }
        return players
    }

    private func getWordForTopic() -> String {
        return selectedTopic.getWordsByTopic().randomElement() ?? ""
    }
}
