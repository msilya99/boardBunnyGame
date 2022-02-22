//
//  Color + EX.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI
import UIKit

extension UIColor {
    convenience init(light lightModeColor: @escaping @autoclosure () -> UIColor,
                     dark darkModeColor: @escaping @autoclosure () -> UIColor) {
        self.init {
            traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return lightModeColor()
            case .dark:
                return darkModeColor()
            default:
                return lightModeColor()
            }
        }
    }

    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }

    /// Check if the color is light or dark, as defined by the injected lightness threshold.
    func isLight(threshold: Float = 0.7) -> Bool? {
        let originalCGColor: CGColor = self.cgColor
        // Now we need to convert it to the RGB colorspace. UIColor.white / UIColor.black are greyscale and not RGB.
        // If you don't do this then you will crash when accessing components index 2 below when evaluating greyscale colors.
        let RGBCGColor: CGColor? = originalCGColor
            .converted(to: CGColorSpaceCreateDeviceRGB(),
                       intent: .defaultIntent, options: nil)
        guard let components: [CGFloat] = RGBCGColor?.components,
              components.count >= 3 else {
                  return nil
              }
        let brightness: Float = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
    }
}

extension Color {
    init(light lightModeColor: @escaping @autoclosure () -> Color,
         dark darkModeColor: @escaping @autoclosure () -> Color) {
        self.init(UIColor(light: UIColor(lightModeColor()), dark: UIColor(darkModeColor()) ))
    }

    func encode() -> Data? {
        var color = self
        let themeColorType = ThemeColors.sh.getTypeByColor(self)
        if themeColorType != .unknown {
            color = BaseColors.sh.getColor(themeColorType,
                                             isLightColor:  UIScreen.main.traitCollection.userInterfaceStyle == .light)
        }

        let object = UIColor(color)
        return try? NSKeyedArchiver.archivedData(withRootObject: object,
                                                 requiringSecureCoding: true)
    }

    static func color(withData data: Data) -> Color? {
        guard let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else { return nil}
        let colorComponents = uiColor.rgba
        return Color(.sRGBLinear,
                     red: colorComponents.red,
                     green: colorComponents.green,
                     blue: colorComponents.blue,
                     opacity: colorComponents.alpha)
    }

    func isLightColor() -> Bool {
        guard let cgColor = self.cgColor else { return false }
        return UIColor(cgColor: cgColor).isLight() ?? false
    }

    func getMainColor(isInverted: Bool = false) -> Color {
        BaseColors.sh.getColor(.base,
                                 isLightColor: isInverted ? !self.isLightColor() : self.isLightColor())
    }

    func getAdditionalColor(isInverted: Bool = false) -> Color {
        BaseColors.sh.getColor(.base02,
                                 isLightColor: isInverted ? !self.isLightColor() : self.isLightColor())
    }
}
