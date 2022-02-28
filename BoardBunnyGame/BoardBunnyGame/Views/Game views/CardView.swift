//
//  CardView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI

struct CardView: View {

    // MARK: - variables

    @State private var translation: CGSize = .zero


    private var player: SinglePlayer
    private var onRemove: (_ player: SinglePlayer) -> Void

    private var thresholdPercentage: CGFloat = 0.5 // when the user has draged 50% the width of the screen in either direction

    // MARK: - init

    init(player: SinglePlayer, onRemove: @escaping (_ player: SinglePlayer) -> Void) {
        self.player = player
        self.onRemove = onRemove
    }

    /// What percentage of our own width have we swipped
    /// - Parameters:
    ///   - geometry: The geometry
    ///   - gesture: The current gesture translation value
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                Flashcard(size: geometry.size) {
                    Text("Игрок номер \(player.id + 1)")
                            .font(.largeTitle)
                            .foregroundColor(BaseColors.sh.getColorByType(.baseLight))
                    } back: {
                        Text("\(player.word)")
                            .font(.largeTitle)
                            .foregroundColor(BaseColors.sh.getColorByType(.baseLight))
                    }
            }
            .offset(x: translation.width, y: 0)
            .rotationEffect(.degrees(Double(translation.width / geometry.size.width) * 40),anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        translation = value.translation
                    }
                    .onEnded { value in
                    // determine snap distance > 0.5 aka half the width of the screen
                        withAnimation(.linear) {
                            if abs(getGesturePercentage(geometry, from: value)) > thresholdPercentage {
                                onRemove(player)
                            } else {
                                translation = .zero
                            }
                        }
                    }
            )
        }
    }
}
