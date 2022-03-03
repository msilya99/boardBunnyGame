//
//  PlayerModel.swift
//  Zaec
//
//  Created by Ilya Maslau on 4.03.22.
//

import Foundation

struct PlayerModel: Hashable, Codable {
    var id: Int
    var word: String? = nil
    var name: String
}
