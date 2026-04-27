//
//  Friend.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import Foundation

// MARK: - Friend Model
struct Friend: Identifiable, Codable {
    let id: UUID
    var name: String
    var phoneNumber: String
    var birthday: Date?
    var note: String?
    var isFavorite: Bool
    var createdAt: Date
    
    init(id: UUID = UUID(), 
         name: String, 
         phoneNumber: String, 
         birthday: Date? = nil, 
         note: String? = nil, 
         isFavorite: Bool = false, 
         createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.birthday = birthday
        self.note = note
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }
}

// MARK: - Mock Data
extension Friend {
    static let mockFriends = [
        Friend(name: "Nguyễn Văn A", phoneNumber: "0123456789", birthday: Date(), isFavorite: true),
        Friend(name: "Trần Thị B", phoneNumber: "0987654321", birthday: Date()),
        Friend(name: "Lê Văn C", phoneNumber: "0369852147", isFavorite: true)
    ]
}
