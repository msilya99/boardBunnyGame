//
//  NavigationBarBackButton.swift
//  Zaec
//
//  Created by Ilya Maslau on 2.03.22.
//

import SwiftUI

struct NavigationBackButton: ViewModifier {

    // MARK: - variables

    @Environment(\.presentationMode) var presentationMode
    var colorType: ThemeColorType
    var text: String?

    // MARK: - gui

    func body(content: Content) -> some View {
        return content
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(action: {  presentationMode.wrappedValue.dismiss() }, label: {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(themeColorType: colorType)

                        if let text = text {
                            Text(text)
                                .foregroundColor(themeColorType: colorType)
                        }
                    }
                })
            )
    }
}

extension View {
    func navigationBackButton(colorType: ThemeColorType, text: String? = "Назад") -> some View {
        modifier(NavigationBackButton(colorType: colorType, text: text))
    }
}
