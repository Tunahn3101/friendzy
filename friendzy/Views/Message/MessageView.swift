//
//  MessageView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 1/5/26.
//

import SwiftUI

struct MessageView: View {
    @StateObject private var store = ChatStore.shared
    @State private var selectedConversation: Conversation? = nil

    var body: some View {
        ZStack {
            Image("bg_mess")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                MesHeader()
                RecentMatches { user in
                    let chatUser = ChatUser(
                        id: user.id,
                        name: user.name,
                        avatar: user.avatarURL
                    )
                    let conv = store.newConversation(with: chatUser)
                    selectedConversation = conv
                }
                ZStack {
                    // full white background that fills to bottom safe area
                    Color.white
                        .ignoresSafeArea(edges: .bottom)

                    ConversationListView(
                        selectedConversation: $selectedConversation
                    )
                    .environmentObject(store)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 16,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 16
                        )
                    )
                }
            }
            .safeAreaPadding(.top, 40)
            .fullScreenCover(item: $selectedConversation) { conv in
                NavigationStack {
                    ChatDetailView(conversationID: conv.id)
                        .environmentObject(store)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct RecentMatches: View {
    var listUserDiscover: [UserModel] = sampleDiscoverUsers
    var onSelect: (UserModel) -> Void = { _ in }

    init(
        listUserDiscover: [UserModel] = sampleDiscoverUsers,
        onSelect: @escaping (UserModel) -> Void = { _ in }
    ) {
        self.listUserDiscover = listUserDiscover
        self.onSelect = onSelect
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Matches")
                .font(.system(size: 16))
                .fontWeight(.medium)
                .foregroundColor(.white)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(listUserDiscover) { item in
                        Button {
                            onSelect(item)
                        } label: {
                            Image(item.avatarURL)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 84, height: 100)
                                .cornerRadius(20)
                                .overlay {
                                    if item.recentMatches != nil {
                                        Color.appPrimary.opacity(0.5)
                                            .cornerRadius(20)
                                        VStack(alignment: .center, spacing: 8) {
                                            Image(systemName: "heart.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(.white)

                                            Text("\(item.recentMatches!)")
                                                .font(.system(size: 16))
                                                .fontWeight(.medium)
                                                .foregroundColor(.white)

                                        }
                                    }

                                }
                        }

                    }
                }
            }
            .frame(height: 100)
            .padding(.leading, 4)

        }
        .padding(.horizontal, 16)
        .padding(.bottom, 22)

    }
}

struct MesHeader: View {
    var body: some View {
        HStack {
            Text("Message")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)

        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
}

struct ConversationListView: View {
    @EnvironmentObject var store: ChatStore
    @Binding var selectedConversation: Conversation?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // header inside white area
            HStack {
                Text("Chats")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            ScrollView {
                // Show items in the same order as RecentMatches (sampleDiscoverUsers)
                LazyVStack(spacing: 12) {
                    ForEach(sampleDiscoverUsers) { user in
                                // find a conversation if exists (match by stable avatar string)
                                let conv = store.conversations.first(where: { $0.user.avatar == user.avatarURL })
                        Button(action: {
                            // open existing conversation or create (without reordering)
                            let chatUser = ChatUser(id: user.id, name: user.name, avatar: user.avatarURL)
                            let c = conv ?? store.newConversation(with: chatUser)
                            selectedConversation = c
                        }) {
                            HStack(spacing: 12) {
                                Image(user.avatarURL)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 56, height: 56)
                                    .cornerRadius(12)

                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(user.name)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                        Spacer()
                                        // last timestamp
                                        if let last = conv?.messages.last {
                                            Text(Self.timeString(from: last.date))
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }

                                    if let last = conv?.messages.last {
                                        Text(last.text)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                    } else {
                                        Text("No messages yet")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }

                                Spacer()

                                // unread badge
                                if let unread = conv?.unreadCount, unread > 0 {
                                    Text(unread > 99 ? "99+" : "\(unread)")
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .padding(6)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .id(user.id)
                    }
                }
                .padding(.vertical, 12)
            }
           
        }
    }

    private static func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "dd/MM/yy"
            return formatter.string(from: date)
        }
    }
}

struct ConversationRow: View {
    let conversation: Conversation

    var body: some View {
        HStack(spacing: 12) {
            Image(conversation.user.avatar)
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 6) {
                Text(conversation.user.name)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                if let last = conversation.messages.last {
                    Text(last.text)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                } else {
                    Text("No messages yet")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}
#Preview {
    MessageView()
}
