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

    var availableCategories: [WordCategory] = []

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

    @Published var categoriesModel: FirebaseCategoriesModel? {
        didSet {
            updateCategories()
        }
    }

    @Published var isTwoBunnyInATeam: Bool = false

    @Published var selectedCategories: Set<WordCategory> {
        didSet {
            userDefaults[.selectedTopics] = selectedCategories
            updateSelectedCategory()
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
            updateSelectedCategory()
        }
    }

    @Published var selectedCategory: WordCategory = .random {
        didSet {
            selectedCategoryTitle = selectedCategory.getTopicTitle()
        }
    }

    @Published var selectedCategoryTitle: String = WordCategory.random.getTopicTitle()

    // MARK: - initialization

    init() {
        self.selectedCategories = userDefaults[.selectedTopics] ?? [.random]
        self.updatePlayerNames()
        self.fetchFirebaseData()
    }

    // MARK: - actions

    func updateSelectedCategory() {
        guard let category = selectedCategories.randomElement() else { return }
        selectedCategory = category
    }

    func startGame(isRestarting: Bool) {
        if isRestarting { updateSelectedCategory() }
        players = getPlayers()
        updateWordsForPlayers()
    }

    func stopGame() {
        updateSelectedCategory()
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
        if selectedCategory == .random {
            var allTopics = availableCategories
            if let indexOfRandom = availableCategories.firstIndex(of: .random) {
                allTopics.remove(at: indexOfRandom)
            }

            if let randomTopic = allTopics.randomElement() {
                selectedCategory = randomTopic
                return categoriesModel?.categories.first(where: { $0.category == randomTopic })?.words.randomElement() ?? ""
            }
        }

        return categoriesModel?.categories.first(where: { $0.category == selectedCategory })?.words.randomElement() ?? ""
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

    private func updateCategories() {
        self.availableCategories = self.categoriesModel?.categories.compactMap( { $0.category } ) ?? []
    }

    // MARK: - firebase

    private func fetchFirebaseData() {
        let docRef = firestoreDB.collection("shouldBeUpdated").document("shouldBeUpdated")
        docRef.getDocument { [weak self] document, error in
            if error == nil, let document = document,
               (try? document.data(as: FirebaseShouldBeUpdatedModel.self))?.shouldBeUpdated == true {
                self?.fetchFirebaseCategoriesModel()
            } else {
                self?.getModelFromFile()
            }
        }
    }

    private func fetchFirebaseCategoriesModel() {
        firestoreDB.collection("topics").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            let models = documents.flatMap { (queryDocumentSnapshot) -> [FirebaseCategoryModel] in
                return (try? queryDocumentSnapshot.data(as: FirebaseCategoriesModel.self).categories) ?? []
            }

            self.saveModelToFile(.init(categories: models))
        }
    }

    // MARK: - db setting from app hardcoded values

    private func getModelFromFile() {
        if let model = TopicsFileManagerHelper().getModelFromFile() {
            self.categoriesModel = model
        } else {
            self.saveModelToFile(self.getCategoriesModel())
        }
    }

    // MARK: - save actions

    private func getCategoriesModel() -> FirebaseCategoriesModel {
        let categories = WordCategory.allCases
        let topics = categories.compactMap { category in
            return FirebaseCategoryModel(id: nil,
                                         category: category,
                                         words: category.getWordsByTopic())
        }

        return FirebaseCategoriesModel(categories: topics)
    }

    private func saveModelToFile(_ model: FirebaseCategoriesModel) {
        let existedCategories = Set(model.categories.compactMap { $0.category })
        self.selectedCategories = self.selectedCategories.intersection(existedCategories)
        self.categoriesModel = model
        TopicsFileManagerHelper().saveModelToFile(model: model)
    }

    /// In case u need update db from scratch
//    private func setDb() {
//        var categories = WordCategory.allCases
//        let topics = categories.flatMap { category in
//            return FirebaseCategoryModel(id: nil,
//                                         category: category,
//                                         words: category.getWordsByTopic())
//        }
//
//        let dbModel = FirebaseCategoriesModel(categories: topics)
//
//        let docRef = firestoreDB.collection("topics").document("topics")
//        try? docRef.setData(from: dbModel)
//    }
}
