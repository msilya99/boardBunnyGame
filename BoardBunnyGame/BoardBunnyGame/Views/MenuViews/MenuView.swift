//
//  MenuView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI

struct MenuView: View {

    // MARK: - variables

    @StateObject private var gameModel: GameModel = GameModel()

    // MARK: - gui

    var body: some View {
        NavigationView {
            Group {
                if gameModel.topicsModel == nil {
                    ActivityIndicatorView()
                } else {
                    MainMenuView()
                }
            }.navigationBarHidden(true)
        }
        .accentColor(ThemeColors.sh.getColorByType(.base))
        .environmentObject(gameModel)
    }
}
