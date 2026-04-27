//
//  UIColors.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import SwiftUI
import UIKit

// MARK: - UIColor từ HEX
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// MARK: - Color từ HEX (SwiftUI)
extension Color {
    init(hex: String, alpha: Double = 1.0) {
        self.init(uiColor: UIColor(hex: hex, alpha: CGFloat(alpha)))
    }
}
