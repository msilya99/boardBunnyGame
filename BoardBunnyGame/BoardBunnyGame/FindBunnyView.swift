//
//  FindBunnyView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI

struct FindBunnyView: View {

    // MARK: - variables

    @EnvironmentObject var gameModel: GameModel

    // MARK: - views

    var body: some View {
        Text("\(gameModel.getWords().first ?? "")")
    }
}
