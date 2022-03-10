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
    var themeColor: Color?
    var text: String?

    // MARK: - gui

    func body(content: Content) -> some View {
        return content
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(action: {  presentationMode.wrappedValue.dismiss() }, label: {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(themeColor: themeColor)

                        if let text = text {
                            Text(text)
                                .foregroundColor(themeColor: themeColor)
                        }
                    }
                })
            )
    }
}

extension View {
    func navigationBackButton(themeColor: Color, text: String? = "Назад") -> some View {
        modifier(NavigationBackButton(themeColor: themeColor, text: text))
    }
}
