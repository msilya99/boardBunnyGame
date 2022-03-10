//
//  FirebaseTopicsModel.swift
//  Zaec
//
//  Created by Ilya Maslau on 10.03.22.
//

import Foundation
import FirebaseFirestoreSwift

struct FirebaseTopicModel: Codable {
    @DocumentID var id: String?
    var topicName: String
    var words: [String]
}

struct FirebaseTopicsModel: Codable {
    var topics: [FirebaseTopicModel]
}
