import UIKit

extension UIColor {

    convenience init(hex: String) {
            var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexString = hexString.replacingOccurrences(of: "#", with: "")

            var rgb: UInt64 = 0
            Scanner(string: hexString).scanHexInt64(&rgb)

            switch hexString.count {
            case 6: // RRGGBB
                let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
                let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
                let b = CGFloat(rgb & 0x0000FF) / 255
                self.init(red: r, green: g, blue: b, alpha: 1)

            case 8: // AARRGGBB
                let a = CGFloat((rgb & 0xFF000000) >> 24) / 255
                let r = CGFloat((rgb & 0x00FF0000) >> 16) / 255
                let g = CGFloat((rgb & 0x0000FF00) >> 8) / 255
                let b = CGFloat(rgb & 0x000000FF) / 255
                self.init(red: r, green: g, blue: b, alpha: a)

            default:
                self.init(white: 0, alpha: 1)
            }
        }
    }
