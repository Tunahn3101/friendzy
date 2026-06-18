//
//  ChatDetailView.swift
//  friendzy
//
//  Created by Tunahn on 18/6/26.
//

import SwiftUI

struct ChatDetailView: View {
    @EnvironmentObject var store: ChatStore
    let conversationID: UUID

    @Environment(\.dismiss) private var dismiss

    @State private var inputText: String = ""
    @State private var scrollToBottom: Bool = false

    var body: some View {
        VStack(spacing: 0) {
        
            if let conv = store.conversation(for: conversationID) {
                HStack(spacing: 12) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                            .frame(width: 36, height: 36)
                            .background(Color(UIColor.systemGray5))
                            .clipShape(Circle())
                    }

                    Image(conv.user.avatar)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .cornerRadius(10)
                    VStack(alignment: .leading) {
                        Text(conv.user.name)
                            .fontWeight(.semibold)
                        Text("Online")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }

            Divider()

            // mark as read when view appears
            .onAppear {
                store.markAsRead(conversationID: conversationID)
            }

            // messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 8) {
                        if let conv = store.conversation(for: conversationID) {
                            ForEach(conv.messages) { msg in
                                        VStack(spacing: 6) {
                                            // timestamp above each message
                                            Text(Self.timeString(from: msg.date))
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                                .frame(maxWidth: .infinity)

                                            HStack {
                                                if msg.isSentByCurrentUser { Spacer() }
                                                Text(msg.text)
                                                    .padding(10)
                                                    .background(
                                                        msg.isSentByCurrentUser
                                                            ? Color.blue
                                                            : Color(.systemGray5)
                                                    )
                                                    .foregroundColor(
                                                        msg.isSentByCurrentUser
                                                            ? .white : .black
                                                    )
                                                    .cornerRadius(12)
                                                    .frame(
                                                        maxWidth: .infinity,
                                                        alignment: msg.isSentByCurrentUser
                                                            ? .trailing : .leading
                                                    )
                                                if !msg.isSentByCurrentUser { Spacer() }
                                            }
                                        }
                                .id(msg.id)
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.vertical, 12)
                    .onChange(of: store.conversations) {
                        (_: [Conversation], _: [Conversation]) in

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            if let last = store.conversation(
                                for: conversationID
                            )?.messages.last {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }

            // input
            HStack(spacing: 8) {
                TextField("Message", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        let text = inputText.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        guard !text.isEmpty else { return }
                        store.sendMessage(
                            conversationID: conversationID,
                            text: text
                        )
                        inputText = ""
                    }

                Button(action: {
                    let text = inputText.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )
                    guard !text.isEmpty else { return }
                    store.sendMessage(
                        conversationID: conversationID,
                        text: text
                    )
                    inputText = ""
                }) {
                    Text("Send")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.appPrimary)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(12)
            .background(Color(UIColor.systemBackground))
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private static func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "dd/MM/yy HH:mm"
            return formatter.string(from: date)
        }
    }
}
