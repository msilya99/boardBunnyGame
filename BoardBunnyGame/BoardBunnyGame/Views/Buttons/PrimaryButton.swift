//
//  PrimaryButton.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI

struct PrimaryButton: View {

    // MARK: - variables

    var title: String
    var action: () -> Void
    var horizontalPadding: CGFloat = 32

    // MARK: - views

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
                .font(.title3)
                .padding()
                .backgroundColor(themeColorType: .base)
                .clipShape(Capsule())
                .padding(.horizontal, horizontalPadding)
                .foregroundColor(themeColorType: .baseInverted)
        }
    }
}
