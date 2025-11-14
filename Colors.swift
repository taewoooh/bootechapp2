import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let a, r, g, b: CGFloat

        // #AARRGGBB (8자리)
        if hexSanitized.count == 8 {
            a = CGFloat((rgb & 0xFF000000) >> 24) / 255
            r = CGFloat((rgb & 0x00FF0000) >> 16) / 255
            g = CGFloat((rgb & 0x0000FF00) >> 8) / 255
            b = CGFloat(rgb & 0x000000FF) / 255

        // #RRGGBB (6자리)
        } else {
            a = 1.0
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255
            b = CGFloat(rgb & 0x0000FF) / 255
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
