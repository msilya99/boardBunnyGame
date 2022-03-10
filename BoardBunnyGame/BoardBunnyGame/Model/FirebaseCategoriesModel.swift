//
//  FirebaseTopicsModel.swift
//  Zaec
//
//  Created by Ilya Maslau on 10.03.22.
//

import Foundation
import FirebaseFirestoreSwift

struct FirebaseCategoryModel: Codable, Hashable, Identifiable {
    enum CodingKeys: CodingKey {
        case category, words, isRandomCategory
    }

    @DocumentID var id: String? = UUID().uuidString
    var category: String
    var words: [String]
    var isRandomCategory: Bool?

    func encode(to encoder: Encoder) throws {
        var map = encoder.container(keyedBy: CodingKeys.self)

        try map.encode(self.category, forKey: .category)
        try map.encode(self.words, forKey: .words)
        try map.encode(self.isRandomCategory, forKey: .isRandomCategory)
    }
}

struct FirebaseCategoriesModel: Codable {
    var categories: [FirebaseCategoryModel]
}
