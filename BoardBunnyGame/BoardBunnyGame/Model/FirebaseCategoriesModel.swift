//
//  FirebaseTopicsModel.swift
//  Zaec
//
//  Created by Ilya Maslau on 10.03.22.
//

import Foundation
import FirebaseFirestoreSwift

struct FirebaseCategoryModel: Codable {
    enum CodingKeys: CodingKey {
        case category, words
    }

    @DocumentID var id: String? = nil
    var category: WordCategory
    var words: [String]

    func encode(to encoder: Encoder) throws {
        var map = encoder.container(keyedBy: CodingKeys.self)

        try map.encode(self.category, forKey: .category)
        try map.encode(self.words, forKey: .words)
    }
}

struct FirebaseCategoriesModel: Codable {
    var categories: [FirebaseCategoryModel]
}
