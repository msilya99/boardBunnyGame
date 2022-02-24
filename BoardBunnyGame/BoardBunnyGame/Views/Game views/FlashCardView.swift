//
//  FlashCardView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 25.02.22.
//

import SwiftUI

struct Flashcard<Front, Back>: View where Front: View, Back: View {
    var front: () -> Front
    var back: () -> Back

    @State var size: CGSize
    @State var flipped: Bool = false

    @State var flashcardRotation = 0.0
    @State var contentRotation = 0.0

    init(size: CGSize, @ViewBuilder front: @escaping () -> Front, @ViewBuilder back: @escaping () -> Back) {
        self.size = size
        self.front = front
        self.back = back
    }

    var body: some View {
        ZStack() {
            if flipped {
                back()
            } else {
                front()
            }
        }
        .frame(height: size.height)
        .frame(maxWidth: .infinity)
        .rotation3DEffect(.degrees(contentRotation), axis: (x: 0, y: 1, z: 0))
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
        .onTapGesture {
            flipFlashcard()
        }
        .rotation3DEffect(.degrees(flashcardRotation), axis: (x: 0, y: 1, z: 0))
    }

    func flipFlashcard() {
        let animationTime = 0.5
        withAnimation(Animation.linear(duration: animationTime)) {
            flashcardRotation += 180
        }

        withAnimation(Animation.linear(duration: 0.001).delay(animationTime / 2)) {
            contentRotation += 180
            flipped.toggle()
        }
    }
}
