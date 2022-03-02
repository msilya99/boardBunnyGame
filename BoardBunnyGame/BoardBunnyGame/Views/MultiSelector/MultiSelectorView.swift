//
//  MultiSelectorView.swift
//  Zaec
//
//  Created by Ilya Maslau on 2.03.22.
//

import SwiftUI

struct MultiSelectionView<Selectable: Identifiable & Hashable>: View {

    // MARK: - variables

    let options: [Selectable]
    let optionToString: (Selectable) -> String

    @Binding var selected: Set<Selectable>

    // MARK: - gui

    var body: some View {
        List {
            ForEach(options) { selectable in
                Button(action: { toggleSelection(selectable: selectable) }) {
                    HStack {
                        Text(optionToString(selectable)).foregroundColor(themeColorType: .base)
                        Spacer()
                        if selected.contains { $0.id == selectable.id } {
                            Image(systemName: "checkmark").foregroundColor(themeColorType: .base)
                        }
                    }
                }.tag(selectable.id)
            }
        }
        .navigationTitle("Выберите темы")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggleSelection(selectable: Selectable) {
        if let existingIndex = selected.firstIndex(where: { $0.id == selectable.id }) {
            selected.remove(at: existingIndex)
        } else {
            selected.insert(selectable)
        }
    }
}
