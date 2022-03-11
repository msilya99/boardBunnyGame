//
//  DefaultsKeys.swift
//  Zaec
//
//  Created by Ilya Maslau on 3.03.22.
//

import Foundation

extension UserDefaults.Key {
    static var selectedTopics: UserDefaults.Key<Set<FirebaseCategoryModel>> {
        return .init(name: "selectedTopics")
    }

    static var playerNames: UserDefaults.Key<[PlayerModel]> {
        return .init(name: "playerNames")
    }

    static var lastUpdateDate: UserDefaults.Key<Date> {
        return .init(name: "lastUpdateDate")
    }
}
