//
//  BoardBunnyGameApp.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI
import Firebase

@main
struct BoardBunnyGameApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MenuView()
        }
    }
}
