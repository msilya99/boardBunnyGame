//
//  TopPurpleView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 24.02.22.
//

import SwiftUI

struct TopPurpleView: View {

    // MARK: - variables

    var size: CGSize

    // MARK: - gui

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.init(#colorLiteral(red: 0.8509803922, green: 0.6549019608, blue: 0.7803921569, alpha: 1)), Color.init(#colorLiteral(red: 1, green: 0.9882352941, blue: 0.862745098, alpha: 1))]), startPoint: .bottom, endPoint: .top)
            .frame(width: size.width * 1.5, height: size.height)
            .background(Color.blue)
            .clipShape(Circle())
            .offset(x: -size.width / 4, y: -size.height / 2)
    }
}
