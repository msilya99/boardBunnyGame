//
//  FirebaseTopicsModel.swift
//  Zaec
//
//  Created by Ilya Maslau on 10.03.22.
//

import Foundation
import FirebaseFirestoreSwift

struct FirebaseTopicModel: Codable {
    enum CodingKeys: CodingKey {
        case topicName, words
    }

    @DocumentID var id: String? = nil
    var topicName: WordCategory
    var words: [String]

    func encode(to encoder: Encoder) throws {
        var map = encoder.container(keyedBy: CodingKeys.self)

        try map.encode(self.topicName, forKey: .topicName)
        try map.encode(self.words, forKey: .words)
    }
}

struct FirebaseTopicsModel: Codable {
    var topics: [FirebaseTopicModel]
}
