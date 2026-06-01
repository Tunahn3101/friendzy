//
//  DiscoverSampleData.swift
//  friendzy
//
//  Created by Tunahn on 1/6/26.
//

import Foundation

struct UserModel: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let avatarURL: String
    let location: String
    let age: Int
    let distance: String
}

let sampleDiscoverUsers: [UserModel] = [
    UserModel(
        name: "Halima",
        avatarURL: "ava_halima",
        location: "B E R L I N",
        age: 19,
        distance: "16"
    ),
    UserModel(
        name: "Vanessa",
        avatarURL: "ava_vanessa",
        location: "M U N I C H",
        age: 18,
        distance: "4,8"
    ),
    UserModel(
        name: "James",
        avatarURL: "ava_james",
        location: "H A N O V E R",
        age: 20,
        distance: "2,2"
    ),
    UserModel(
        name: "Eddie",
        avatarURL: "ava_eddie",
        location: "D O R T M U N D",
        age: 23,
        distance: "2"
    ),
    UserModel(
        name: "Brandon",
        avatarURL: "ava_brandon",
        location: "H A M B U R G",
        age: 20,
        distance: "2,5"
    ),
    UserModel(
        name: "Alfredo",
        avatarURL: "ava_alfredo",
        location: "H A M B U R G",
        age: 20,
        distance: "2,5"
    ),

]
