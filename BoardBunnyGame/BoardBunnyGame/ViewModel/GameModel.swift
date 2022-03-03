//
//  GameModel.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import Combine
import SwiftUI
import Foundation

struct SinglePlayer: Hashable {
    var id: Int
    var word: String
}

class GameModel: ObservableObject {

    // MARK: - variables

    private let userDefaults: UserDefaults = .standard

    @AppStorage("numberOfPlayers") var numberOfPlayers: Int = 4

    @Published var topics: Set<WordCategory> {
        didSet {
            userDefaults[.selectedTopics] = self.topics
            self.updateSelectedTopic()
        }
    }

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

    // MARK: - initialization

    init() {
        self.topics = userDefaults[.selectedTopics] ?? [.random]
    }

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
        if selectedTopic == .random {
            var allTopics = WordCategory.allCases
            if let indexOfRandom = WordCategory.allCases.firstIndex(of: .random) {
                allTopics.remove(at: indexOfRandom)
            }

            if let randomTopic = allTopics.randomElement() {
                self.selectedTopic = randomTopic
                return randomTopic.getWordsByTopic().randomElement() ?? ""
            }
        }

        return selectedTopic.getWordsByTopic().randomElement() ?? ""
    }
}
