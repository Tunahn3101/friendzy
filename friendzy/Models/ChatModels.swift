//
//  ChatModels.swift
//  friendzy
//
//  Created by copilot on 2026-06-18.
//

import Foundation
import Combine

struct ChatUser: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let avatar: String
}

struct ChatMessage: Identifiable, Codable, Hashable {
    let id: UUID
    let text: String
    let isSentByCurrentUser: Bool
    let date: Date

    init(id: UUID = UUID(), text: String, isSentByCurrentUser: Bool, date: Date = Date()) {
        self.id = id
        self.text = text
        self.isSentByCurrentUser = isSentByCurrentUser
        self.date = date
    }
}

// Legacy types for migration (older app versions without `unreadCount`)
private struct LegacyChatUser: Codable {
    let id: UUID
    let name: String
    let avatar: String
}

private struct LegacyChatMessage: Codable {
    let id: UUID
    let text: String
    let isSentByCurrentUser: Bool
    let date: Date
}

private struct LegacyConversation: Codable {
    let id: UUID
    let user: LegacyChatUser
    let messages: [LegacyChatMessage]
}

struct Conversation: Identifiable, Codable, Hashable {
    let id: UUID
    var user: ChatUser
    var messages: [ChatMessage]
    var unreadCount: Int

    init(id: UUID = UUID(), user: ChatUser, messages: [ChatMessage] = [], unreadCount: Int = 0) {
        self.id = id
        self.user = user
        self.messages = messages
        self.unreadCount = unreadCount
    }
}

final class ChatStore: ObservableObject {
    static let shared = ChatStore()

    @Published var conversations: [Conversation] = []

    private let key = "friendzy_conversations_v1"
    private let fileName = "friendzy_conversations_v1.json"

    private var cancellables = Set<AnyCancellable>()

    init() {
        load()
        // persist on change (keep as backup for general changes)
        $conversations
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.save()
            }
            .store(in: &cancellables)
    }

    private func load() {
        // Prefer reading from a file in Application Support for more reliable persistence
        if let fileURL = dataFileURL(), let data = try? Data(contentsOf: fileURL) {
            do {
                let decoder = JSONDecoder()
                let list = try decoder.decode([Conversation].self, from: data)
                self.conversations = deduplicated(list)
                return
            } catch {
                print("Failed to decode conversations (new model from file):", error)
                // Try to decode legacy format (older app versions without `unreadCount`)
                do {
                    let decoder = JSONDecoder()
                    let legacy = try decoder.decode([LegacyConversation].self, from: data)
                    let migrated = legacy.map { lc -> Conversation in
                        let user = ChatUser(id: lc.user.id, name: lc.user.name, avatar: lc.user.avatar)
                        let messages = lc.messages.map { m in
                            ChatMessage(id: m.id, text: m.text, isSentByCurrentUser: m.isSentByCurrentUser, date: m.date)
                        }
                        return Conversation(id: lc.id, user: user, messages: messages, unreadCount: 0)
                    }
                    self.conversations = deduplicated(migrated)
                    // persist migrated data
                    save()
                    return
                } catch {
                    print("Failed to decode legacy conversations from file:", error)
                }
            }
        }

        // if file read failed, try UserDefaults for backwards compatibility
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let list = try decoder.decode([Conversation].self, from: data)
                self.conversations = deduplicated(list)
                return
            } catch {
                print("Failed to decode conversations (new model) from UserDefaults:", error)
            }
        }

        // fallback: create from sample users
        createSampleConversations()
    }

    private func save() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(conversations)

            // write to file in Application Support
            if let url = dataFileURL() {
                let fm = FileManager.default
                let folder = url.deletingLastPathComponent()
                if !fm.fileExists(atPath: folder.path) {
                    try fm.createDirectory(at: folder, withIntermediateDirectories: true)
                }
                try data.write(to: url, options: .atomic)
            }

            // also save to UserDefaults for compatibility
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save conversations:", error)
        }
    }

    private func dataFileURL() -> URL? {
        do {
            let fm = FileManager.default
            let appSupport = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            return appSupport.appendingPathComponent(fileName)
        } catch {
            print("Failed to get Application Support directory:", error)
            return nil
        }
    }

    private func createSampleConversations() {
        // lazy import of sampleDiscoverUsers (from UserSampleData)
        var result: [Conversation] = []
        for (i, u) in sampleDiscoverUsers.enumerated() {
            let chatUser = ChatUser(id: u.id, name: u.name, avatar: u.avatarURL)
            // initial message is from the other side (incoming)
            let first = ChatMessage(text: "Chào, mình là \(u.name)", isSentByCurrentUser: false, date: Date().addingTimeInterval(TimeInterval(-3600 * (i + 1))))
            // compute unread based on incoming messages (only count messages not sent by current user)
            let messages = [first]
            let unread = messages.filter { !$0.isSentByCurrentUser }.count
            let conv = Conversation(user: chatUser, messages: messages, unreadCount: unread)
            result.append(conv)
        }
        self.conversations = result
    }

    private func deduplicated(_ input: [Conversation]) -> [Conversation] {
        // Deduplicate by stable user key (avatar) instead of UUID which may change between runs
        var seen: Set<String> = []
        var output: [Conversation] = []
        for conv in input {
            let key = conv.user.avatar
            if !seen.contains(key) {
                seen.insert(key)
                output.append(conv)
            }
        }
        return output
    }

    func conversation(for id: UUID) -> Conversation? {
        conversations.first { $0.id == id }
    }

    func markAsRead(conversationID: UUID) {
        guard let idx = conversations.firstIndex(where: { $0.id == conversationID }) else { return }
        conversations[idx].unreadCount = 0
        save()
    }

    func sendMessage(conversationID: UUID, text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard let idx = conversations.firstIndex(where: { $0.id == conversationID }) else { return }

        let message = ChatMessage(text: text, isSentByCurrentUser: true)
        conversations[idx].messages.append(message)
        // persist immediately
        save()

        // auto-reply after short delay with fixed text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self else { return }
            let reply = ChatMessage(text: "Đéo", isSentByCurrentUser: false)
            if let i = self.conversations.firstIndex(where: { $0.id == conversationID }) {
                self.conversations[i].messages.append(reply)
                // increment unread counter for incoming message
                self.conversations[i].unreadCount += 1
                // persist immediately after reply arrives
                self.save()
            }
        }
    }

    func newConversation(with user: ChatUser) -> Conversation {
        // If a conversation with this user already exists, return it (do not reorder)
        // match by a stable property (avatar)
        if let idx = conversations.firstIndex(where: { $0.user.avatar == user.avatar }) {
            return conversations[idx]
        }

        // Otherwise create a new one and append (do not force to front)
        let conv = Conversation(user: user, messages: [])
        conversations.append(conv)
        // persist created conversation
        save()
        return conv
    }
}
