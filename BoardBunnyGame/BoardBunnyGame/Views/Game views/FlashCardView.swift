//
//  FlashCardView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 25.02.22.
//

import SwiftUI

struct Flashcard<Front, Back>: View where Front: View, Back: View {

    // MARK: - variables
    
    var front: () -> Front
    var back: () -> Back

    @State var size: CGSize
    @State var flipped: Bool = false
    @State var showIndicator: Bool = true

    @State var flashcardRotation = 0.0
    @State var contentRotation = 0.0

    // MARK: - initialization

    init(size: CGSize, @ViewBuilder front: @escaping () -> Front, @ViewBuilder back: @escaping () -> Back) {
        self.size = size
        self.front = front
        self.back = back
    }

    // MARK: - gui variables

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Group {
                if flipped {
                    back()
                } else {
                    front()
                }
            }
            .frame(height: size.height)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()

            if showIndicator {
                IndicatorView()
            }
        }
        .rotation3DEffect(.degrees(contentRotation), axis: (x: 0, y: 1, z: 0))
        .rotation3DEffect(.degrees(flashcardRotation), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            flipFlashcard()
        }
    }

    func flipFlashcard() {
        let animationTime = 0.5
        withAnimation(Animation.linear(duration: animationTime)) {
            flashcardRotation += 180
        }

        withAnimation(Animation.linear(duration: 0.001).delay(animationTime / 2)) {
            contentRotation += 180
            flipped.toggle()
            showIndicator = false
        }
    }
}

struct IndicatorView:  View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.init(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)), Color.init(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))]), startPoint: .bottom, endPoint: .top)
            .frame(width: 16, height: 16)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 0.3))
            .padding(24)
    }
}
