//
//  MultiSelector.swift
//  Zaec
//
//  Created by Ilya Maslau on 2.03.22.
//

import SwiftUI

struct MultiSelector<LabelView: View, Selectable: Identifiable & Hashable>: View {
    let label: LabelView
    let options: [Selectable]
    let optionToString: (Selectable) -> String

    var selected: Binding<Set<Selectable>>

    private var formattedSelectedListString: String {
        guard let singleTheme = selected.wrappedValue.single else { return "Несколько тем" }
        return optionToString(singleTheme)
    }

    var body: some View {
        NavigationLink(destination: multiSelectionView()) {
            HStack {
                label
                    .foregroundColor(themeColorType: .baseInverted)
                Spacer()
                Text(formattedSelectedListString)
                    .foregroundColor(themeColorType: .baseInverted)
            }
        }
    }

    private func multiSelectionView() -> some View {
        MultiSelectionView(
            options: options,
            optionToString: optionToString,
            selected: selected
        )
    }
}
