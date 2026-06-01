//
//  User.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var avatar: String?
    var friends: [UUID]

    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        avatar: String? = nil,
        friends: [UUID] = []
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.avatar = avatar
        self.friends = friends
    }
}
