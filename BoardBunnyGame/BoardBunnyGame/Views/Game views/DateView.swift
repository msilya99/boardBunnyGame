//
//  DateView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 2.03.22.
//

import SwiftUI

struct DateView: View {

    // MARK: - variables

    @Binding var text: String

    // MARK: - gui

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(text)
                    .foregroundColor(BaseColors.sh.getColorByType(.baseLight))
                    .font(.title)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
