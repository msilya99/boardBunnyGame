//
//  SelectedTopicView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI

struct SelectedTopicView: View {

    //MARK: - variables

    @EnvironmentObject var gameModel: GameModel
    @State private var isActive: Bool = false

    // MARK: - views
    
    var body: some View {
        VStack {
            Text("Выбранная тема: \(gameModel.topic)")
            Spacer()
            
            PrimaryButton(title: "Продолжить") {
                isActive = true
            }

            NavigationLink(destination: FindBunnyView(),
                           isActive: $isActive) { }
        }
    }
}
