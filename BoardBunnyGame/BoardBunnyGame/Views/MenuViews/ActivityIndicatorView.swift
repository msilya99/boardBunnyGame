//
//  ActivityIndicator.swift
//  Zaec
//
//  Created by Ilya Maslau on 10.03.22.
//

import SwiftUI

struct ActivityIndicatorView: View {

    // MARK: - variables
    @State var animate = false
    @State var color = Color.gray

    let style = StrokeStyle(lineWidth: 6, lineCap: .round)

    // MARK: - gui

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    BaseColors.sh.getColorByType(.bunnyPink)

                    Color.white
                        .frame(maxWidth: geometry.size.width * 0.6, maxHeight: geometry.size.width * 0.6)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

                    ZStack {
                        Circle()
                            .trim(from: 0, to: 0.2)
                            .stroke(AngularGradient(colors: [color], center: .center), style: style)
                            .rotationEffect(Angle(degrees: animate ? 360 : 0))
                            .animation(.linear(duration: 0.7).repeatForever(autoreverses: false), value: animate)

                        Circle()
                            .trim(from: 0.5, to: 0.7)
                            .stroke(AngularGradient(colors: [color], center: .center), style: style)
                            .rotationEffect(Angle(degrees: animate ? 360 : 0))
                            .animation(.linear(duration: 0.7).repeatForever(autoreverses: false), value: animate)
                    }
                    .frame(maxWidth: geometry.size.width * 0.3)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }

            }
        }
        .ignoresSafeArea()
        .onAppear { animate.toggle() }
    }
}
