//
//  DefaultsKeys.swift
//  Zaec
//
//  Created by Ilya Maslau on 3.03.22.
//

import Foundation

extension UserDefaults.Key {
    static var selectedTopics: UserDefaults.Key<Set<WordCategory>> {
        return .init(name: "selectedTopics")
    }
}
