//
//  FirebaseTopicsModel.swift
//  Zaec
//
//  Created by Ilya Maslau on 10.03.22.
//

import Foundation

struct FirebaseTopicModel: Decodable {
    var topicName: String
    var words: [String]
}

struct FirebaseTopicsModel: Decodable {
    var topics: [FirebaseTopicModel]
}
