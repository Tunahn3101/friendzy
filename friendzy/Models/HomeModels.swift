//
//  HomeModels.swift
//  friendzy
//
//  Created for refactor: chứa các model sử dụng trong HomeView
//

import Foundation

struct Story: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let avatarURL: String
    let localVideoName: String?
}

struct MakeFriendsModel: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let bgImage: String
    let favorite: String
    let location: String
    let iconFavorite: String
    let quote: String
    let avatarURL: String
}
