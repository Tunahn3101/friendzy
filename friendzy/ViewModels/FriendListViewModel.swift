//
//  FriendListViewModel.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import Foundation
import SwiftUI
import Combine

// MARK: - FriendListViewModel
class FriendListViewModel: ObservableObject {
    // Published properties - khi thay đổi sẽ tự động cập nhật UI
    @Published var friends: [Friend] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init() {
        loadFriends()
    }
    
    // MARK: - Computed Properties
    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return friends
        }
        return friends.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var favoriteFriends: [Friend] {
        friends.filter { $0.isFavorite }
    }
    
    // MARK: - Methods
    func loadFriends() {
        isLoading = true
        // Giả lập loading data (sau này có thể thay bằng API call)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.friends = Friend.mockFriends
            self.isLoading = false
        }
    }
    
    func addFriend(_ friend: Friend) {
        friends.append(friend)
        saveFriends()
    }
    
    func updateFriend(_ friend: Friend) {
        if let index = friends.firstIndex(where: { $0.id == friend.id }) {
            friends[index] = friend
            saveFriends()
        }
    }
    
    func deleteFriend(at offsets: IndexSet) {
        friends.remove(atOffsets: offsets)
        saveFriends()
    }
    
    func toggleFavorite(for friend: Friend) {
        if let index = friends.firstIndex(where: { $0.id == friend.id }) {
            friends[index].isFavorite.toggle()
            saveFriends()
        }
    }
    
    // MARK: - Private Methods
    private func saveFriends() {
        // Lưu vào UserDefaults hoặc Core Data
        // Đơn giản hóa cho người mới học
        if let encoded = try? JSONEncoder().encode(friends) {
            UserDefaults.standard.set(encoded, forKey: "SavedFriends")
        }
    }
    
    private func loadSavedFriends() {
        if let savedData = UserDefaults.standard.data(forKey: "SavedFriends"),
           let decoded = try? JSONDecoder().decode([Friend].self, from: savedData) {
            friends = decoded
        }
    }
}
