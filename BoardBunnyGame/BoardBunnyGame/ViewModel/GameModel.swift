//
//  GameModel.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import Combine
import SwiftUI
import Foundation

class GameModel: ObservableObject {

    // MARK: - variables

    private let userDefaults: UserDefaults = .standard

    @AppStorage("numberOfPlayers") var numberOfPlayers: Int = 4 {
        didSet {
            handleCountChange()
        }
    }

    @AppStorage("isUsingCustomNames") var isUsingCustomNames: Bool = false {
        didSet {
            updatePlayerNames()
        }
    }

    @Published var topics: Set<WordCategory> {
        didSet {
            userDefaults[.selectedTopics] = topics
            updateSelectedTopic()
        }
    }

    @Published var playerNamesModels: [PlayerModel] = [] {
        didSet {
            guard isUsingCustomNames else { return }
            userDefaults[.playerNames] = playerNamesModels
        }
    }

    @Published var players: [PlayerModel] = [] {
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
        self.updatePlayerNames()
    }

    // MARK: - actions

    func updateSelectedTopic() {
        guard let topic = topics.randomElement() else { return }
        selectedTopic = topic
    }

    func startGame(isRestarting: Bool) {
        if isRestarting { updateSelectedTopic() }
        players = getPlayers()
        updateWordsForPlayers()
    }

    func stopGame() {
        updateSelectedTopic()
        players = []
    }

    func getDefaultName(id: Int) -> String {
        return "Игрок номер \(id)"
    }

    // MARK: - private actions

    private func handleCountChange() {
        if numberOfPlayers < playerNamesModels.count {
            playerNamesModels.removeLast()
        } else if numberOfPlayers > playerNamesModels.count {
            playerNamesModels.append(PlayerModel(id: numberOfPlayers, name: getDefaultName(id: numberOfPlayers)))
        }
    }

    private func updateWordsForPlayers() {
        var words = Array(repeating: getWordForTopic(), count: numberOfPlayers - 1)
        words.append("ЗАЕЦццц!")
        words.shuffle()

        for id in 0..<players.count {
            players[id].word = words.removeFirst()
        }
    }

    private func getWordForTopic() -> String {
        if selectedTopic == .random {
            var allTopics = WordCategory.allCases
            if let indexOfRandom = WordCategory.allCases.firstIndex(of: .random) {
                allTopics.remove(at: indexOfRandom)
            }

            if let randomTopic = allTopics.randomElement() {
                selectedTopic = randomTopic
                return randomTopic.getWordsByTopic().randomElement() ?? ""
            }
        }

        return selectedTopic.getWordsByTopic().randomElement() ?? ""
    }

    private func getPlayers() -> [PlayerModel] {
        players = []
        if isUsingCustomNames, var customPlayers = userDefaults[.playerNames] {
            if customPlayers.count < numberOfPlayers {
                for id in customPlayers.count..<numberOfPlayers {
                    customPlayers.append(PlayerModel(id: id + 1, name: getDefaultName(id: id + 1)))
                }
            } else if customPlayers.count > numberOfPlayers {
                customPlayers.removeLast(customPlayers.count - numberOfPlayers)
            }
            return customPlayers
        } else {
            var defaultPlayers: [PlayerModel] = []
            for id in 0..<numberOfPlayers {
                defaultPlayers.append(PlayerModel(id: id + 1, name: getDefaultName(id: id + 1)))
            }

            return defaultPlayers
        }
    }

    private func updatePlayerNames() {
        playerNamesModels = getPlayers()
    }
}
