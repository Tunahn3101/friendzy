//
//  MatchesSampleData.swift
//  friendzy
//
//  Created by Tunahn on 17/6/26.
//

import Foundation

struct MatchesModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let avatarURL: String
    let icon: String?
    let count: Int
    let distance: String?

    init(
        id: UUID = UUID(),
        title: String,
        avatarURL: String,
        icon: String? = nil,
        count: Int,
        distance: String? = nil
    ) {
        self.id = id
        self.title = title
        self.avatarURL = avatarURL
        self.icon = icon
        self.count = count
        self.distance = distance
    }
}

let sampleMatchesUsers: [MatchesModel] = [
    MatchesModel(
        title: "Likes",
        avatarURL: "ava_halima",
        icon: "heart.fill",
        count: 19,
    ),
    MatchesModel(
        title: "Connect",
        avatarURL: "ava_vanessa",
        icon: "message.fill",
        count: 15,
    ),
    MatchesModel(
        title: "James",
        avatarURL: "ava_james",
        count: 20,
    ),
    MatchesModel(
        title: "Eddie",
        avatarURL: "ava_eddie",
        count: 23,
    ),
    MatchesModel(
        title: "Brandon",
        avatarURL: "ava_brandon",
        count: 20,
    ),
    MatchesModel(
        title: "Alfredo",
        avatarURL: "ava_alfredo",
        count: 20,

    ),

]

