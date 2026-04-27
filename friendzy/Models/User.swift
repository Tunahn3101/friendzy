//
//  User.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import Foundation

// MARK: - User Model
struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var avatar: String?
    var friends: [UUID]
    
    init(id: UUID = UUID(), name: String, email: String, avatar: String? = nil, friends: [UUID] = []) {
        self.id = id
        self.name = name
        self.email = email
        self.avatar = avatar
        self.friends = friends
    }
}

// MARK: - Mock Data
extension User {
    static let mockUsers = [
        User(name: "Tuấn Anh", email: "tuananh@example.com", avatar: "person.circle.fill"),
        User(name: "Minh Hà", email: "minhha@example.com", avatar: "person.circle.fill"),
        User(name: "Đức Anh", email: "ducanh@example.com", avatar: "person.circle.fill"),
        User(name: "Thu Hà", email: "thuha@example.com", avatar: "person.circle.fill")
    ]
}
