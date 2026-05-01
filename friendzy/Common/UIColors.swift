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
    
    // Định nghĩa các màu chủ đạo để dùng trong toàn app
    // Dễ maintain, chỉ cần đổi ở 1 chỗ → toàn app thay đổi
    
    /// Màu hồng chính của app - #DD88CF
    static let appPrimary = Color(hex: "0xFFDD88CF")
    
    /// Màu hồng nhạt (cho background, hover states)
    static let appPrimaryLight = Color(hex: "0xFFDD88CF", alpha: 0.2)
    
    /// Màu hồng đậm (cho pressed states, borders)
    static let appPrimaryDark = Color(hex: "0xFFC066B8")
    
    /// Background màu hồng rất nhạt cho toàn app
    static let appBackground = Color(hex: "0xFFFDF7FD")
    
    /// Màu accent (có thể dùng cho highlights)
    static let appAccent = Color(hex: "0xFFFF69B4")
}
