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

    private var player: PlayerModel
    private var onRemove: (_ player: PlayerModel) -> Void
    private var thresholdPercentage: CGFloat = 0.3 // when the user has draged 30% the width of the screen in either direction

    // MARK: - init

    init(player: PlayerModel, onRemove: @escaping (_ player: PlayerModel) -> Void) {
        self.player = player
        self.onRemove = onRemove
    }

    // MARK: - gui

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                Flashcard(size: geometry.size) {
                    Text("\(player.name)")
                        .font(.largeTitle)
                        .foregroundColor(BaseColors.sh.getColorByType(.baseLight))
                } back: {
                    Text("\(player.word ?? "Произошла ошибка")")
                        .font(.largeTitle)
                        .foregroundColor(BaseColors.sh.getColorByType(.baseLight))
                }
            }
            .offset(x: translation.width, y: 0)
            .rotationEffect(.degrees(Double(translation.width / geometry.size.width) * 30),anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        translation = value.translation
                    }
                    .onEnded { value in
                        // determine snap distance > 0.3 aka half the width of the screen
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

    /// What percentage of our own width have we swipped
    /// - Parameters:
    ///   - geometry: The geometry
    ///   - gesture: The current gesture translation value
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
}
