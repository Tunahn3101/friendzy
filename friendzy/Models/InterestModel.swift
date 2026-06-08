//
//  InterestModel.swift
//  friendzy
//
//  Created on 1/5/26.
//

import Foundation
import SwiftUI

struct InterestModel: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var icon: String
    var colorHex: String  // Màu riêng cho từng interest
    var isSelected: Bool
    
    init(id: UUID = UUID(), name: String, icon: String, colorHex: String, isSelected: Bool = false) {
        self.id = id
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
        self.isSelected = isSelected
    }
    
    var color: Color {
        Color(hex: colorHex)
    }
}

let sampleInterests: [InterestModel] = [
    InterestModel(name: "Travel", icon: "airplane", colorHex: "0xFF5B9BD5"),        // Xanh dương
    InterestModel(name: "Music", icon: "music.note", colorHex: "0xFFED7D32"),       // Cam
    InterestModel(name: "Photography", icon: "camera.fill", colorHex: "0xFFA5A5A5"), // Xám
    InterestModel(name: "Sports", icon: "figure.run", colorHex: "0xFF70AD47"),       // Xanh lá
    InterestModel(name: "Cooking", icon: "fork.knife", colorHex: "0xFFFFC000"),      // Vàng
    InterestModel(name: "Reading", icon: "book.fill", colorHex: "0xFF9E480E"),       // Nâu
    InterestModel(name: "Gaming", icon: "gamecontroller.fill", colorHex: "0xFF7030A0"), // Tím đậm
    InterestModel(name: "Art", icon: "paintbrush.fill", colorHex: "0xFFE91E63"),     // Hồng
    InterestModel(name: "Fitness", icon: "dumbbell.fill", colorHex: "0xFFFF5722"),   // Đỏ cam
    InterestModel(name: "Movies", icon: "film.fill", colorHex: "0xFF4A5568"),        // Xám đen
    InterestModel(name: "Coffee", icon: "cup.and.saucer.fill", colorHex: "0xFF795548"), // Nâu cafe
    InterestModel(name: "Pets", icon: "pawprint.fill", colorHex: "0xFFFF9800"),      // Cam vàng
    InterestModel(name: "Fashion", icon: "bag.fill", colorHex: "0xFFF06292"),        // Hồng nhạt
    InterestModel(name: "Technology", icon: "laptopcomputer", colorHex: "0xFF00BCD4"), // Xanh cyan
    InterestModel(name: "Nature", icon: "leaf.fill", colorHex: "0xFF4CAF50"),        // Xanh lá cây
    InterestModel(name: "Dance", icon: "figure.dance", colorHex: "0xFF9C27B0")       // Tím hồng
]
