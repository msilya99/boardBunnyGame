//
//  ViewThemeColorModifier.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI

enum ViewThemeType {
    case background
    case foreground
}

struct ViewThemeColorModifier: ViewModifier {

    // MARK: - variables

    @Environment(\.colorScheme) private var colorScheme

    var type: ViewThemeType
    var themeColor: Color?
    var themeColorType: ThemeColorType?

    // MARK: - view

    func body(content: Content) -> some View {
        switch type {
        case .background:
            getBackgroundThemeView(content: content)
        case .foreground:
            getForegroundThemeView(content: content)
        }
    }

    // MARK: - get color by theme

    private func getThemeColor(colorType: ThemeColorType) -> Color {
        return ThemeColors.sh.getColorByType(colorType)
    }

    @ViewBuilder
    private func getBackgroundThemeView(content: Content) -> some View {
        if let themeColor = themeColor {
            content.background(themeColor)
        } else if let themeColorType = themeColorType {
            content.background(getThemeColor(colorType: themeColorType))
        } else {
            content
        }
    }

    @ViewBuilder
    private func getForegroundThemeView(content: Content) -> some View {
        if let themeColor = themeColor {
            content.foregroundColor(themeColor)
        } else if let themeColorType = themeColorType {
            content.foregroundColor(getThemeColor(colorType: themeColorType))
        } else {
            content
        }
    }
}

extension View {
    func foregroundColor(themeColor: Color? = nil, themeColorType: ThemeColorType? = nil) -> some View {
        modifier(ViewThemeColorModifier(type: .foreground,
                                          themeColor: themeColor,
                                          themeColorType: themeColorType))
    }

    func backgroundColor(themeColor: Color? = nil, themeColorType: ThemeColorType? = nil) -> some View {
        modifier(ViewThemeColorModifier(type: .background,
                                          themeColor: themeColor,
                                          themeColorType: themeColorType))
    }
}
