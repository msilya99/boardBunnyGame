//
//  CardView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI

struct CardView: View {
    @State private var translation: CGSize = .zero

    private var player: SinglePlayer
    private var onRemove: (_ player: SinglePlayer) -> Void

    private var thresholdPercentage: CGFloat = 0.5 // when the user has draged 50% the width of the screen in either direction


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
            VStack(alignment: .leading) {
                ZStack(alignment: .center) {
                    Color.white
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                    Text("Клацни чтобы узнать кто ты")
                        .font(.largeTitle)
                }
            }
            .padding(.bottom)
            .cornerRadius(10)
            .shadow(radius: 5)
            .offset(x: self.translation.width, y: 0)
            .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 40),
                            anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.translation = value.translation
                    }
                    .onEnded { value in
                    // determine snap distance > 0.5 aka half the width of the screen
                        withAnimation(.linear) {
                            if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                                self.onRemove(self.player)
                            } else {
                                self.translation = .zero
                            }
                        }
                    }
            )
        }
    }
}
