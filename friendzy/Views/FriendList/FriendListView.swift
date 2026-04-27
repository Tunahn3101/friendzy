//
//  FriendListView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import SwiftUI

struct FriendListView: View {
    @ObservedObject var viewModel: FriendListViewModel
    
    var body: some View {
        List {
            // Phần bạn yêu thích
            if !viewModel.favoriteFriends.isEmpty {
                Section(header: Text("⭐ Yêu thích")) {
                    ForEach(viewModel.favoriteFriends) { friend in
                        FriendRowView(friend: friend, viewModel: viewModel)
                    }
                }
            }
            
            // Tất cả bạn bè
            Section(header: Text("Tất cả bạn bè")) {
                ForEach(viewModel.filteredFriends) { friend in
                    FriendRowView(friend: friend, viewModel: viewModel)
                }
                .onDelete(perform: viewModel.deleteFriend)
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Tìm kiếm bạn bè")
        .refreshable {
            viewModel.loadFriends()
        }
    }
}

// MARK: - Friend Row View
struct FriendRowView: View {
    let friend: Friend
    @ObservedObject var viewModel: FriendListViewModel
    
    var body: some View {
        HStack {
            // Avatar
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
            
            // Thông tin
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.headline)
                
                Text(friend.phoneNumber)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let note = friend.note {
                    Text(note)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Favorite button
            Button(action: {
                viewModel.toggleFavorite(for: friend)
            }) {
                Image(systemName: friend.isFavorite ? "star.fill" : "star")
                    .foregroundColor(friend.isFavorite ? .yellow : .gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FriendListView(viewModel: FriendListViewModel())
}
