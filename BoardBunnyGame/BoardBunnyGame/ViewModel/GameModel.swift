//
//  GameModel.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import Combine
import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class GameModel: ObservableObject {

    // MARK: - variables

    private let firestoreDB = Firestore.firestore()
    private let userDefaults: UserDefaults = .standard
    private var topicsModel: FirebaseTopicsModel?

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

    @Published var isTwoBunnyInATeam: Bool = false

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
        self.fetchFirebaseData()
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
        let minesWords = isTwoBunnyInATeam ? 2 : 1
        var words = Array(repeating: getWordForTopic(), count: numberOfPlayers - minesWords)
        words.append("ЗАЕЦццц!")
        if isTwoBunnyInATeam {
            words.append("ЗАЕЦццц!")
        }
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

    // MARK: - firebase

    private func fetchFirebaseData() {
        let docRef = firestoreDB.collection("shouldBeUpdated").document("shouldBeUpdated")
        docRef.getDocument { [weak self] document, error in
            guard let self = self, error == nil, let document = document else { return }
            if (try? document.data(as: FirebaseShouldBeUpdatedModel.self))?.shouldBeUpdated == true {
                self.fetchFirebaseTopicsModel()
            } else {
                self.getModelFromFile()
            }
        }
    }

    private func fetchFirebaseTopicsModel() {
        firestoreDB.collection("topics").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            let models = documents.flatMap { (queryDocumentSnapshot) -> [FirebaseTopicModel] in
                return (try? queryDocumentSnapshot.data(as: FirebaseTopicsModel.self).topics) ?? []
            }

            self.saveModelToFile(.init(topics: models))
        }
    }

    // MARK: - db setting from app hardcoded values

    private func getModelFromFile() {
        if let model = TopicsFileManagerHelper().getModelFromFile() {
            print(model)
        } else {
            self.saveModelToFile(self.getTopicsModel())
        }
    }

    // MARK: - save actions

    private func getTopicsModel() -> FirebaseTopicsModel {
        let categories = WordCategory.allCases
        let topics = categories.compactMap { category in
            return FirebaseTopicModel(id: nil,
                                      topicName: category,
                                      words: category.getWordsByTopic())
        }

        return FirebaseTopicsModel(topics: topics)
    }

    private func saveModelToFile(_ model: FirebaseTopicsModel) {
        self.topicsModel = model
        TopicsFileManagerHelper().saveModelToFile(model: model)
    }

    //    private func setDb() {
    //        var categories = WordCategory.allCases
    //        let topics = categories.flatMap { category in
    //            return FirebaseTopicModel(id: nil,
    //                                      topicName: category,
    //                                      words: category.getWordsByTopic())
    //        }
    //
    //        let dbModel = FirebaseTopicsModel(topics: topics)
    //
    //        let docRef = firestoreDB.collection("topics").document("topics")
    //        try? docRef.setData(from: dbModel)
    //    }
}
